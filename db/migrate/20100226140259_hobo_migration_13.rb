class HoboMigration13 < ActiveRecord::Migration
  def self.up
    add_column :invoices, :billable_entity_id, :integer, :null => false
  end

  def self.down
    remove_column :invoices, :billable_entity_id
  end
end
