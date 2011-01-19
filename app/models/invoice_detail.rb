class InvoiceDetail < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    locked :boolean
    post_dt :date
    amount :float, {:null => false}
    notes :string, {:limit => 1024}
    timestamps
  end

  belongs_to :invoice_detail_type
  belongs_to :invoice

  def name
    "#{amount}(#{invoice_detail_type.name})"
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
