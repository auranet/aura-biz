class HoboMigration16 < ActiveRecord::Migration
  def self.up
    add_column :invoice_details, :amount, :float, :null => false
  end

  def self.down
    remove_column :invoice_details, :amount
  end
end
