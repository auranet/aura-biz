class LockHours < ActiveRecord::Migration
  def self.up
    add_column :task_hours, :locked, :string, :limit => 1
  end

  def self.down
    remove_column :task_hours, :locked
  end
end
