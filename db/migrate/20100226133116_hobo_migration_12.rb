class HoboMigration12 < ActiveRecord::Migration
  def self.up
    add_column :invoice_details, :locked, :boolean
    add_column :invoice_details, :post_dt, :date
    add_column :invoice_details, :invoice_id, :integer

    add_index :invoice_details, [:invoice_id]

    add_index :invoices, [:billable_period_id, :customer_id, :partner_id], :unique => true, :name => 'invoices_uk1'
  end

  def self.down
    remove_column :invoice_details, :locked
    remove_column :invoice_details, :post_dt
    remove_column :invoice_details, :invoice_id

    remove_index :invoice_details, :name => :index_invoice_details_on_invoice_id rescue ActiveRecord::StatementInvalid

    remove_index :invoices, :name => :invoices_uk1 rescue ActiveRecord::StatementInvalid
  end
end
