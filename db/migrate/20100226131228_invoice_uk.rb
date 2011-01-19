class InvoiceUk < ActiveRecord::Migration
  def self.up
    execute 'alter table invoices add constraint invoices_uk1 unique (billable_period_id,customer_id,partner_id)'
  end

  def self.down
    execute 'alter table invoices drop constraint invoices_uk1'
  end
end
