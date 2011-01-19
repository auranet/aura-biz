class TaskHour < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    hours :float
    locked :string, {:limit => 1}
    timestamps
  end

  belongs_to :employee
  belongs_to :billable_task
  belongs_to :billable_period

  def name
    "#{employee.name}:#{billable_task.name}:#{billable_period.name}=#{hours}"
  end

  def generate_billing_detail
#     partner_contract = billable_task.partner_contract
#     partner_contract_rate = BillRate.find_only_one(:all, :conditions => "employee_id = #{employee.id} and partner_contract_id = #{partner_contract.id} and #{billable_period.effective_dt} between effective_dt and expiration_dt")

    partner_contract = billable_task.partner_contract

    rate = BillRate.find_first_match(:employee => employee,
                                     :partner_contract => partner_contract,
                                     :billable_period => billable_period,
                                     :billable_task => billable_task)

    raise "cannot find rate schedule for #{employee.name} on #{billable_task.name} (task_hours id: #{id}).  If you believe that you are receiving this in error check that all employees have valid rates (and that the effective and expiration date are correctly set)." unless rate 
    

#    raise  unless partner_contract_rate or employee_task_rate

    actual_bill_rate = rate.rate # (employee_task_rate ? employee_task_rate.rate : (partner_contract_rate ? partner_contract_rate.rate : 0))
    pay_rate = rate.pay_rate # (employee_task_rate ? employee_task_rate.pay_rate : (partner_contract_rate ? partner_contract_rate.pay_rate : 0))

    billable_amount = hours * actual_bill_rate
    payable_amount = hours * pay_rate

    BillingDetail.create(:billable_task => billable_task,
                         :billable_period => billable_period,
                         :employee_id => employee.id,
                         :partner_contract => partner_contract,
                         :partner => partner_contract.partner,
                         :customer => partner_contract.customer,
                         :invoice_partner => partner_contract.invoice_partner,
                         :partner_contract_rate_id => nil,
                         :employee_task_rate_id => nil,
                         :billable_amount => billable_amount,
                         :payable_amount => payable_amount,
                         :billable_hours => hours,
                         :bill_rate => rate,
                         :actual_bill_rate => actual_bill_rate,
                         :pay_rate => pay_rate,
                         :task_hour_id => id)

                         
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
