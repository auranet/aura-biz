class Customer < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    timestamps
  end

  has_many :partner_contracts


  # --- Permissions --- #

  def unpaid_invoices(h={})
    extras=" "
    if not_after = h[:not_after]
      extras = " AND ((year = #{not_after.year} and month <= #{not_after.month}) or (year < #{not_after.year})) "
    end
    UnpaidClientInvoiceV.find_by_sql("select * from unpaid_client_invoice_v where customer_id = #{id} #{extras} order by year asc, month asc")
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
