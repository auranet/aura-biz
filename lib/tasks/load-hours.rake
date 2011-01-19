begin  
  require 'rubygems'
  require 'ckuru-tools'
  require 'ruby-debug'
  require 'fastercsv'

  class String
    def justify(chars=2)
      sprintf("%0#{chars}d",self)
    end
  end

  def String.db_date(month,day,year,start=true)
    adapter = TaskHour.connection.instance_variable_get("@config")[:adapter]

    if adapter == "oracle"
      "to_date('#{month.to_s.justify}/#{day.to_s.justify}/#{year.to_s.justify(4)} #{start ? '00:00:00' : '23:59:59'}','MM/DD/YY HH24:MI:SS')"
    elsif adapter == "postgresql"
      "TIMESTAMP '#{year.to_s.justify(4)}/#{month.to_s.justify}/#{day.to_s.justify}' "
    else
      raise "no format string for adapter #{adapter}"
    end
  end

  namespace :load do
    desc "Load tasks"
    task(:hours => :environment) do

      if matchdata = ARGV[0].match(/\[(.+?)\]/)
        filename = matchdata[1]
      end

      raise "usage: : rake load:hours[filename]" unless filename
      ckebug 0, "filename = #{filename}"

      if matchdata  = filename.match(/[\.\/a-z]+task_by_user_(\d+)-(\d+)-(\d+)_to_(\d+)-(\d+)-(\d+).csv/)

        from = String.db_date(*matchdata[1..3])
        to = String.db_date(*matchdata[4..6].push(false))

        #
        # The next section pretty much assumes monthly billing periods.  If this were to change this next piece
        # would need to be refactored.
        #
        month = matchdata[1]
        year = matchdata[3]
        
        raise "can not process data across multiple months" unless
          month == matchdata[4] and
          year == matchdata[6]

        raise "something seems off on the date range of the input file: #{file}" unless
          (matchdata[2] == "1" and  matchdata[5].match(/^[23][8901]/))

        raise "you cannot process multiple months at a time : #{matchdata}" if 
          matchdata[1] != matchdata[4] or
          matchdata[3] != matchdata[6]

        month,year = matchdata[1],matchdata[3] # bogus unless we process one month at a time.

        billable_period = BillablePeriod.find_or_create(:conditions => {
                                                          :month => month,
                                                          :year => year
                                                        })
        
        ckebug 0, (sql = "delete from task_hours where billable_period_id = #{billable_period.id} and (locked is null or locked = 'N')")
        TaskHour.connection.execute sql

        firstrow=true
        employees = []
        employee_row_map = {}
        FasterCSV.foreach(filename) do |row|
          break if row[0].match(/Total Hours/)
          ckebug 0, "processing #{row.join(',')}"
          if firstrow
            firstrow=false
            colnum=-1
            row.each do |col|
              colnum += 1
              next if colnum < 1
              next if col.match(/Total Hours/)

              first_name,last_name = col.split(/\s+/)

              if emp = Employee.find_only_one(:all, :conditions => {:first_name => first_name, :last_name => last_name})
                employees.push(emp)
                employee_row_map[colnum] = emp
              else
                raise "cannot find employee #{col}"
              end
            end
          else # row
            colnum=-1
            task = nil
            row.each do |col|
              colnum += 1
              if colnum == 0
                unless task = BillableTask.find_only_one(:all,
                                                         :conditions => "name = '#{col}' and (disabled is null or disabled = false)"
                                                         )
                  #
                  # TODO: "select or create" this
                  #
                  raise "no such billable task #{col}"
                end
              else
                if col.match(/\d/)
                  if emp = employee_row_map[colnum] # emp will be null for the total hours so we skip
                    new = TaskHour.create(:billable_task => task, 
                                          :employee => emp, 
                                          :hours => col,  
                                          :billable_period => billable_period)
                    new.reload
                    ckebug 0, new.inspect
                  end
                end
              end
            end
          end
        end
      else
        raise "invalid filename #{filename}"
      end
    end # task
  end   # namespace
end
