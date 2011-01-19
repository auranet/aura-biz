class HoboMigration4 < ActiveRecord::Migration
  def self.up
    rename_column :employees, :name, :first_name
    add_column :employees, :last_name, :text
    add_column :employees, :ssn, :text
    remove_column :employees, :monthly_cost
    remove_column :employees, :title
    remove_column :employees, :monthly_salary

    add_column :employee_details, :type, :text
  end

  def self.down
    rename_column :employees, :first_name, :name
    remove_column :employees, :last_name
    remove_column :employees, :ssn
    add_column :employees, :monthly_cost, :float
    add_column :employees, :title, :text
    add_column :employees, :monthly_salary, :float

    remove_column :employee_details, :type
  end
end
