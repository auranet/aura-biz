class HoboMigration20 < ActiveRecord::Migration
  def self.up
    change_column :billable_periods, :locked_dt, :timestamp
    change_column :billable_periods, :last_maintenace_dt, :timestamp
  end

  def self.down
    change_column :billable_periods, :locked_dt, :date
    change_column :billable_periods, :last_maintenace_dt, :date
  end
end
