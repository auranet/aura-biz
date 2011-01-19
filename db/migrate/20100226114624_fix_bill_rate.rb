class FixBillRate < ActiveRecord::Migration
  def self.up
    rename_column :billing_details, :bill_rate, :actual_bill_rate
  end

  def self.down
    rename_column :billing_details, :actual_bill_rate, :bill_rate
  end
end
