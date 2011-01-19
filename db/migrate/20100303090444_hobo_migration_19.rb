class HoboMigration19 < ActiveRecord::Migration
  def self.up
    add_column :billable_periods, :last_maintenace_dt, :date
    add_column :billable_periods, :locked_dt, :date
  end

  def self.down
    remove_column :billable_periods, :last_maintenace_dt
    remove_column :billable_periods, :locked_dt
  end
end
