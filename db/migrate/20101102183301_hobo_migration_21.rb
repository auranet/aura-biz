class HoboMigration21 < ActiveRecord::Migration
  def self.up
    add_column :billable_tasks, :disabled, :boolean
  end

  def self.down
    remove_column :billable_tasks, :disabled
  end
end
