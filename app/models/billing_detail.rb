class BillingDetail < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billable_hours :float, {:null => false}
    billable_amount :float, {:null => false}
    payable_amount :float
    actual_bill_rate :float, {:null => false}
    pay_rate :float
    partner_contract_rate_id :integer
    employee_task_rate_id :integer
    invoice_partner :boolean
    timestamps
  end

  belongs_to :employee
  belongs_to :billable_task
  belongs_to :bill_rate
  belongs_to :partner_contract
  belongs_to :partner
  belongs_to :customer
  belongs_to :billable_period
  belongs_to :task_hour

  def billable_task_name
    billable_task ? billable_task.name : '?'
  end

  def profit
    billable_amount - (payable_amount ? payable_amount : 0)
  end

  def hours
    billable_hours
  end

  def self.organize_by_employee(arr)
    BillableDetailSet.new(arr)
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

class BillableDetailSet

  attr_accessor :hours
  attr_accessor :billable_amount
  attr_accessor :employee_sets
  
  def initialize(arr)
    bds = {}
    arr.each do |rec|
      bds[rec.employee_id] = BillingDetailForEmployee.new(bds[rec.employee_id]) unless bds[rec.employee_id]
      bds[rec.employee_id].push rec
    end
    self.employee_sets = bds
    self.hours = 0
    self.billable_amount = 0

    bds.keys.each do |emp|
      self.hours += bds[emp].hours
      self.billable_amount += bds[emp].billable_amount
    end
  end

  def each
    employee_sets.keys.each do |k|
      yield(employee_sets[k])
    end
  end
end

class BillingDetailForEmployee 
  attr_accessor :rows
  attr_accessor :hours
  attr_accessor :billable_amount
  attr_accessor :id
  
  def initialize(id)
    self.rows = []
    self.hours = 0
    self.billable_amount = 0
    self.id = id
  end

  def push(rec)
    self.rows.push(rec)
    self.hours += rec.hours 
    self.billable_amount += rec.billable_amount
  end
end
