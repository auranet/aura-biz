class HoboMigration7 < ActiveRecord::Migration
  def self.up
    add_column :partner_contracts, :partner_id, :integer
    add_column :partner_contracts, :customer_id, :integer

    add_index :partner_contracts, [:partner_id]
    add_index :partner_contracts, [:customer_id]
  end

  def self.down
    remove_column :partner_contracts, :partner_id
    remove_column :partner_contracts, :customer_id

    remove_index :partner_contracts, :name => :index_partner_contracts_on_partner_id rescue ActiveRecord::StatementInvalid
    remove_index :partner_contracts, :name => :index_partner_contracts_on_customer_id rescue ActiveRecord::StatementInvalid
  end
end
