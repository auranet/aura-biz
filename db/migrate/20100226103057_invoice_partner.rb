class InvoicePartner < ActiveRecord::Migration
  def self.up
    add_column :billing_details, :payable_amount, :float
    add_column :billing_details, :bill_rate, :float, :null => false

    add_column :partner_contracts, :invoice_partner, :boolean
  end

  def self.down
    remove_column :billing_details, :payable_amount
    remove_column :billing_details, :bill_rate

    remove_column :partner_contracts, :invoice_partner
  end
end
