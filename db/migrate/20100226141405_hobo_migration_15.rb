class HoboMigration15 < ActiveRecord::Migration
  def self.up
    add_index :invoice_detail_types, [:name], :unique => true, :name => 'invoice_detail_types_uk1'
  end

  def self.down
    remove_index :invoice_detail_types, :name => :invoice_detail_types_uk1 rescue ActiveRecord::StatementInvalid
  end
end
