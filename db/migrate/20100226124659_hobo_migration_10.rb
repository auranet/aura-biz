class HoboMigration10 < ActiveRecord::Migration
  def self.up
    add_column :billable_periods, :locked, :boolean
  end

  def self.down
    remove_column :billable_periods, :locked
  end
end
