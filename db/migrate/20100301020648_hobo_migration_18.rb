class HoboMigration18 < ActiveRecord::Migration
  def self.up
    add_column :invoice_details, :notes, :string, :limit => 1024
  end

  def self.down
    remove_column :invoice_details, :notes
  end
end
