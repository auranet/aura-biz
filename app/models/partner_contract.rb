class PartnerContract < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    invoice_partner :boolean
    timestamps
  end

  belongs_to :partner
  belongs_to :customer
  has_many :bill_rates
  has_many :billable_tasks

  def name
    "#{partner.name} - #{customer.name}"
  end

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
