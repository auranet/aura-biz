class HoboMigration9 < ActiveRecord::Migration
  def self.up
    create_table :task_hours do |t|
      t.float    :hours
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :employee_id
      t.integer  :billable_task_id
      t.integer  :billable_period_id
    end
    add_index :task_hours, [:employee_id]
    add_index :task_hours, [:billable_task_id]
    add_index :task_hours, [:billable_period_id]

    create_table :billable_periods do |t|
      t.integer  :month
      t.integer  :year
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :task_hours
    drop_table :billable_periods
  end
end
