# CkuruExtensions

# Active Record extensions

require 'ckuru-tools'

class String
  def justify(chars=2)
    sprintf("%0#{chars}d",self)
  end
end

class ARDummy < ActiveRecord::Base
  def self.config_adapter
    connection.instance_variable_get("@config")[:adapter]
  end
end

module ActiveRecord
  class Base

    def self.db_date(month,day,year,start=true)
      adapter = self.config_adapter

      if adapter == "oracle"
        "to_date('#{month.to_s.justify}/#{day.to_s.justify}/#{year.to_s.justify(4)} #{start ? '00:00:00' : '23:59:59'}','MM/DD/YY HH24:MI:SS')"
      elsif adapter == "postgresql"
        "TIMESTAMP '#{year.to_s.justify(4)}/#{month.to_s.justify}/#{day.to_s.justify}' "
      else
        raise "no format string for adapter #{adapter}"
      end
    end

    def self.config_adapter
      ARDummy.config_adapter
    end

    def self.find_only_one(*args)
      ret = find(*args)
      if ret.length == 1
        ret[0]
      elsif ret.length == 0
        nil
      else
        raise "#{current_method} found multiple records #{args.inspect}"
      end
    end

    def self.find_all(h={})
      
      find_by_sql("select #{h[:distinct] ? 'distinct' : ''} * from #{table_name}")
    end

    def self.natural_key
      "#{table_name}_name"
    end

    #
    # If passed a string, looks up the canonical record (based on natural key).
    # Typically for "our" tables if the table_name is PERSON; it will be searching
    # basied on the PERSON_NAME field.
    #
    # If passed a non string; just calls activerecord find.
    #
    # Mostly syntactic sugar to alleviate type find_by_yadda_yadda_yadda which I hate to
    # type
    #
    # Example:
    #   MyClass.finder("Abe Lincoln") 
    #
    #   is equivalent to
    #
    #   MyClass.find_by_myclass_name("Abe Lincoln")
    #
    #   MyClass.finder(:myclass_name,"Abe  Lincoln") # hey why not!?
    #
    #   MyClass.finder(12) # just like .find()
    
    def self.finder(v,val=nil)
      ckebug(1, v.class) if defined? ckebug
      if v.is_a? String
        self.send("find_by_#{natural_key}".to_sym,v)
      elsif v.class == Symbol
        self.send("find_by_#{v}".to_sym,val)
      else
        self.send(:find,v)
      end
    end

    ################################################################################

    def self.find_or_create(h={})
      conditions = h[:conditions] or raise "set :conditions"
      require = h[:require] || h[:required]

      e = ret = nil
      if ret = find_only_one(:all, :conditions => conditions)
        ckebug 0, "found #{self.class.to_s} record : #{conditions.inspect}"
      else
        begin
          ret = create(conditions)
          ckebug 0, "created #{self.class.to_s} record : #{conditions.inspect}"
        rescue Exception => e
        end
      end
      if ret.nil? and require
        raise "failed to create a #{self.class.to_s} record for #{conditions.inspect}#{e ? ': ' + e : nil}"
      end
      ret
    end

    ################################################################################
  end
end

unless (ActiveScaffold rescue nil).nil?
  ActiveScaffold::DataStructures::Column # force rails to load the class
  class ActiveScaffold::DataStructures::Column
    def form_ui
      @association.nil? ? @form_ui : :select
    end
  end
end

