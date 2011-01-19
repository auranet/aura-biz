module InvoiceHelper
  def self.link_to_invoice(inv)
    raise "illegal type passed to #{current_method}" unless inv.class == Invoice
    ret = ""
    [:html,:msword,:pdf].each do |fmt|
      ret += "<a href=\"/document_generators/invoice/#{inv.id}?format=#{fmt}\" target=\"blank\">#{fmt}</a>&nbsp;" 
    end
    ret
  end
end
