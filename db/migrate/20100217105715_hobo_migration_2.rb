class HoboMigration2 < ActiveRecord::Migration
  def self.up
    create_table :employee_details do |t|
      t.float    :salary
      t.string   :title
      t.float    :cost
      t.date     :start_dt
      t.date     :end_dt
      t.datetime :created_at
      t.datetime :updated_at
    end

    remove_column :employees, :end_dt
    remove_column :employees, :start_dt
  end

  def self.down
    add_column :employees, :end_dt, :datetime
    add_column :employees, :start_dt, :datetime

    drop_table :employee_details
  end
end
