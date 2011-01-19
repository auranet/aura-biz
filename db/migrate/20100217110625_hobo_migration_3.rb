class HoboMigration3 < ActiveRecord::Migration
  def self.up
    add_column :employee_details, :employee_id, :integer

    add_index :employee_details, [:employee_id]
  end

  def self.down
    remove_column :employee_details, :employee_id

    remove_index :employee_details, :name => :index_employee_details_on_employee_id rescue ActiveRecord::StatementInvalid
  end
end
