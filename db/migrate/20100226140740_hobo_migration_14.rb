class HoboMigration14 < ActiveRecord::Migration
  def self.up
    add_column :invoices, :billable_entity_type, :string, :null => false, :limit => 32

    remove_index :invoices, :name => :invoices_uk1 rescue ActiveRecord::StatementInvalid
    add_index :invoices, [:billable_period_id, :billable_entity_id, :billable_entity_type], :unique => true, :name => 'invoices_uk1'
  end

  def self.down
    remove_column :invoices, :billable_entity_type

    remove_index :invoices, :name => :invoices_uk1 rescue ActiveRecord::StatementInvalid
    add_index :invoices, [:billable_period_id, :customer_id, :partner_id], :unique => true, :name => 'invoices_uk1'
  end
end
