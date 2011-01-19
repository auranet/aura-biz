class UnpaidClientInvoiceV < ActiveRecord::Base
  set_primary_key "invoice_id"
  set_table_name :unpaid_client_invoice_v

  belongs_to :invoice

  def invoiced_amount
    i_amt
  end

  def credit_pre_pays
    r_amt - x_amt
  end

  def amount_paid
    p_amt
  end

  def amount_credited
    c_amt
  end

  def total_paid_and_credited
    amount_paid + amount_credited
  end

  def invoiced_total
    total_invoiceable
  end

  def amount_owed
    (i_amt + r_amt + a_amt) - total_paid_and_credited
  end

end
