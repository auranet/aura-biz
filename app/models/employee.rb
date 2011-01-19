class Employee < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # I think if an employee is rehired, the data should be manage with the employee_details table.
  fields do
    first_name :string
    last_name :string
    employment_start_dt :date
    employment_end_dt :date
    ssn :string
    timestamps
  end

  has_many :bill_rates
  has_many :employee_details

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator?
  end

  def name
    "#{first_name} #{last_name}"
  end

end
