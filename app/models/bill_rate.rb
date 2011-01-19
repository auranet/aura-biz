class BillRate < ActiveRecord::Base
  
  hobo_model # Don't put anything above this
  
  fields do
    rate     :float, {:default => 0}
    pay_rate     :float, {:default => 0}
    effective_dt :date
    expiration_dt   :date
    timestamps
  end
  
  belongs_to :employee
  belongs_to :billable_task
  belongs_to :partner_contract
  
  def self.find_first_match(h={})
    employee = h[:employee] or raise "set :employee in #{current_method}"
    billable_period = h[:billable_period] or raise "set :billable_period in #{current_method}"
    billable_task = h[:billable_task] or raise "set :billable_task in #{current_method}"
    partner_contract = h[:partner_contract] or raise "set :partner_contract in #{current_method}"

#    debugger if employee.first_name.match(/Bret/) and partner_contract.name.match(/Medtronic/)

    if full = BillRate.find_only_one(:all, :conditions => "employee_id = #{employee.id} and billable_task_id = #{billable_task.id} and partner_contract_id = #{partner_contract.id} and #{billable_period.effective_dt} between effective_dt and expiration_dt")
      return full
    elsif notask = BillRate.find_only_one(:all, :conditions => "employee_id = #{employee.id} and billable_task_id is null and partner_contract_id = #{partner_contract.id} and #{billable_period.effective_dt} between effective_dt and expiration_dt")
      return notask
    elsif noemp = BillRate.find_only_one(:all, :conditions => "billable_task_id = #{billable_task.id} and partner_contract_id = #{partner_contract.id} and employee_id is null and #{billable_period.effective_dt} between effective_dt and expiration_dt")
      return noemp
    else
      begin 
        if contract_only = BillRate.find_only_one(:all, :conditions => "partner_contract_id = #{partner_contract.id} and billable_task_id is null and employee_id is null and #{billable_period.effective_dt} between effective_dt and expiration_dt")
          return contract_only
        else
          return nil
        end
      rescue Exception => e
        raise "cannot find rate schedule for #{employee.name} on #{billable_task.name} .  If you believe that you are receiving this in error check that all employees have valid rates (and that the effective and expiration date are correctly set)."        
      end
    end
    nil
#                                        :employee => employee,
#                                        :billable_task => billable_task,
#                                        :partner_contract => partner_contract
                                       

  #     unless employee_task_rate = BillRate.find_only_one(:all, :conditions => "employee_id = #{employee.id} and billable_task_id = #{billable_task_id} and #{billable_period.effective_dt} between effective_dt and expiration_dt")
  #       employee_task_rate = BillRate.find_only_one
    
  end
  
  
  
  def employee_name
    "#{employee ? employee.name : 'all'}"
  end
  
  def full_name
    "#{employee_name}:#{billable_task ? billable_task.name : '<no task>'}:#{partner_contract ? partner_contract.name : '<no contract>'}:#{rate}"
  end
  
  def name
    "#{employee_name}(#{rate})"
  end
  
  # --- Permissions --- #
  
  def create_permitted?
    acting_user.administrator?
  end
  
  def update_permitted?
    acting_user.administrator?
  end
  
  def destroy_permitted?
    acting_user.administrator?
  end
  
  def view_permitted?(field)
    acting_user.administrator?
  end
  
end
