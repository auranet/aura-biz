class HoboMigration17 < ActiveRecord::Migration
  def self.up
    add_column :invoices, :closed, :boolean
  end

  def self.down
    remove_column :invoices, :closed
  end
end
