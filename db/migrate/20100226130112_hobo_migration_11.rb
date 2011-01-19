class HoboMigration11 < ActiveRecord::Migration
  def self.up
    create_table :invoice_detail_types do |t|
      t.string   :name, :unique => true, :null => false, :limit => 1
      t.string   :description, :null => false, :limit => 128
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :invoice_details do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :invoice_detail_type_id
    end
    add_index :invoice_details, [:invoice_detail_type_id]

    create_table :invoices do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :billable_period_id
      t.integer  :customer_id
      t.integer  :partner_id
    end
    add_index :invoices, [:billable_period_id]
    add_index :invoices, [:customer_id]
    add_index :invoices, [:partner_id]
  end

  def self.down
    drop_table :invoice_detail_types
    drop_table :invoice_details
    drop_table :invoices
  end
end
