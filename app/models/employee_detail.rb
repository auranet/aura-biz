class EmployeeDetail < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    yearly_salary   :float
    yearly_vacation_days :float
    yearly_flex_days :float
    title    :string
    cost     :float
    effective_dt :date
    employee_type :text
    expiration_dt   :date
    timestamps
  end

  belongs_to :employee

  # --- Permissions --- #

  def name
    "#{employee.name}: #{effective_dt}-#{expiration_dt}"
  end

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

end
