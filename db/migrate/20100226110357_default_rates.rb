class DefaultRates < ActiveRecord::Migration
  def self.up
    change_column :bill_rates, :pay_rate, :float, :default => 0
    change_column :bill_rates, :rate, :float, :default => 0
  end

  def self.down
    change_column :bill_rates, :pay_rate, :float
    change_column :bill_rates, :rate, :float
  end
end
