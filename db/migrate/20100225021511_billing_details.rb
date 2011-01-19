class BillingDetails < ActiveRecord::Migration
  def self.up
    create_table :billing_details do |t|
      t.float    :billable_amount, :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :employee_id
      t.integer  :billable_task_id
      t.integer  :bill_rate_id
      t.integer  :partner_contract_id
      t.integer  :partner_id
      t.integer  :customer_id
      t.integer  :billable_period_id
      t.integer  :task_hour_id
    end
    add_index :billing_details, [:employee_id]
    add_index :billing_details, [:billable_task_id]
    add_index :billing_details, [:bill_rate_id]
    add_index :billing_details, [:partner_contract_id]
    add_index :billing_details, [:partner_id]
    add_index :billing_details, [:customer_id]
    add_index :billing_details, [:billable_period_id]
    add_index :billing_details, [:task_hour_id]
  end

  def self.down
    drop_table :billing_details
  end
end
