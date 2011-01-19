class BillableTask < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    disabled  :boolean
    timestamps
  end

  belongs_to :partner_contract
  has_many :bill_rates
  has_many :task_hours

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

end
