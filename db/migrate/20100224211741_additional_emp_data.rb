class AdditionalEmpData < ActiveRecord::Migration
  def self.up
    rename_column :employee_details, :salary, :yearly_salary
    add_column :employee_details, :yearly_vacation_days, :float
    add_column :employee_details, :yearly_flex_days, :float

    rename_column :bill_rates, :end_dt, :expiration_dt
    rename_column :bill_rates, :start_dt, :effective_dt
  end

  def self.down
    rename_column :employee_details, :yearly_salary, :salary
    remove_column :employee_details, :yearly_vacation_days
    remove_column :employee_details, :yearly_flex_days

    rename_column :bill_rates, :expiration_dt, :end_dt
    rename_column :bill_rates, :effective_dt, :start_dt
  end
end
