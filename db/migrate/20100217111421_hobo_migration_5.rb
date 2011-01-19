class HoboMigration5 < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    remove_column :employees, :type
  end

  def self.down
    add_column :employees, :type, :text

    drop_table :customers
  end
end
