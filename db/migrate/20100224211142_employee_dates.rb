class EmployeeDates < ActiveRecord::Migration
  def self.up
    add_column :employees, :employment_start_dt, :date
    add_column :employees, :employment_end_dt, :date

    rename_column :employee_details, :end_dt, :expiration_dt
    rename_column :employee_details, :start_dt, :effective_dt
  end

  def self.down
    remove_column :employees, :employment_start_dt
    remove_column :employees, :employment_end_dt

    rename_column :employee_details, :expiration_dt, :end_dt
    rename_column :employee_details, :effective_dt, :start_dt
  end
end
