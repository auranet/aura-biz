class PayRate < ActiveRecord::Migration
  def self.up
    add_column :bill_rates, :pay_rate, :float

    add_column :billing_details, :invoice_partner, :boolean
  end

  def self.down
    remove_column :bill_rates, :pay_rate

    remove_column :billing_details, :invoice_partner
  end
end
