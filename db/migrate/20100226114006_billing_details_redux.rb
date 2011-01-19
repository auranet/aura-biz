class BillingDetailsRedux < ActiveRecord::Migration
  def self.up
    add_column :billing_details, :billable_hours, :float, :null => false
    add_column :billing_details, :pay_rate, :float
    add_column :billing_details, :partner_contract_rate_id, :integer
    add_column :billing_details, :employee_task_rate_id, :integer
  end

  def self.down
    remove_column :billing_details, :billable_hours
    remove_column :billing_details, :pay_rate
    remove_column :billing_details, :partner_contract_rate_id
    remove_column :billing_details, :employee_task_rate_id
  end
end
