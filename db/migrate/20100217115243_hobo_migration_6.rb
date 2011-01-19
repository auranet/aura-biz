class HoboMigration6 < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :partner_contracts do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :partners
    drop_table :partner_contracts
  end
end
