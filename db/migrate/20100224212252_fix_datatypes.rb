class FixDatatypes < ActiveRecord::Migration
  def self.up
    change_column :employees, :ssn, :string, :limit => 255
    change_column :employees, :last_name, :string, :limit => 255
    change_column :employees, :first_name, :string, :limit => 255

    rename_column :employee_details, :type, :employee_type
  end

  def self.down
    change_column :employees, :ssn, :text
    change_column :employees, :last_name, :text
    change_column :employees, :first_name, :text

    rename_column :employee_details, :employee_type, :type
  end
end
