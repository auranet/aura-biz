class HoboMigration8 < ActiveRecord::Migration
  def self.up
    create_table :billable_tasks do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :partner_contract_id
    end
    add_index :billable_tasks, [:partner_contract_id]

    create_table :bill_rates do |t|
      t.float    :rate
      t.date     :start_dt
      t.date     :end_dt
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :employee_id
      t.integer  :billable_task_id
      t.integer  :partner_contract_id
    end
    add_index :bill_rates, [:employee_id]
    add_index :bill_rates, [:billable_task_id]
    add_index :bill_rates, [:partner_contract_id]
  end

  def self.down
    drop_table :billable_tasks
    drop_table :bill_rates
  end
end
