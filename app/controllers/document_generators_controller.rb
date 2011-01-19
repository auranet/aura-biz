class DocumentGeneratorsController < ApplicationController


  def invoice
    #    format = params[:format]
    id = params[:id]
    @error_message = []

    if @invoice = Invoice.find(id)

      @billable_entity = @invoice.billable_entity

      if @invoice.closed_month?
        raise "not implemented"

        @oldinvoice = Invoice.find_by_month(id, {:month => @invoice.month, :year => @invoice.year})

        @invoice = @oldinvoice
        _billing_details = @invoice.find_children_by_month(BillingDetail, 
                                                           :conditions => {
                                                             :client_id => @invoice.client_id,
                                                             :invoice_month_id => @invoice.invoice_month_id
                                                           })

        @billing_details =    _billing_details.select {|x| x.purchase_order_id.nil?}
        @po_details = _billing_details.select {|x| ! x.purchase_order_id.nil?}

        credit_prepays = @invoice.find_children_by_month(CreditPrepayV, 
                                                         :conditions => {
                                                           :client_id => @invoice.client_id,
                                                         }) rescue nil

        
        @credit_prepays =  (@total_credit = CreditPrepayV.total_credit(credit_prepays)) != 0 ? credit_prepays : nil

        @unpaid_invoices = @invoice.find_children_by_month(UnpaidClientInvoiceV,
                                                           :conditions => {
                                                             :client_id => @invoice.client_id,
                                                             })

        @invoice_details = @invoice.find_children_by_month(InvoiceDetail, {:month => @invoice.month, :year => @invoice.year})

        @status = "Final"
      else
        @status = "Draft"
        implemented_purchase_orders = false
        if implemented_purchase_orders
          @billing_details = @invoice.billing_details.select {|x| x.purchase_order_id.nil?}
          @po_details = @invoice.billing_details.select {|x| ! x.purchase_order_id.nil?}
        else
          @billing_details = @invoice.billing_details
        end
        @invoice_details = @invoice.invoice_details
#        @credit_prepays = (@total_credit =  CreditPrepayV.total_credit_for_client(@invoice.client_id)) != 0 ? @invoice.client.credit_prepays : nil
#        @unpaid_invoices = @invoice.billable_entity.unpaid_invoices(:not_after => @invoice)

        @unpaid_invoices = @invoice.billable_entity.unpaid_invoices(:not_after => @invoice)
      end
        
    else
      @error_message.push("Failed to find a record for that id #{id}.")      
    end

    if @error_message.length == 0
      @employee_billing_details = BillingDetail.organize_by_employee(@billing_details)
      filename = (@invoice.name ? @invoice.name : '').gsub(/\//,"-")

      respond_to do |format|
        format.pdf {
          #       if format and format.match(/pdf/i)
          if data = render_to_pdf({:action => 'invoice', :layout => false })
            send_data(data,:filename => "#{filename}-invoice.pdf", :type => "application/pdf")
          else
            raise "failed to generate pdf ... check the rails logs for the htmldoc error"
          end
        }
        format.msword {
          @format = :msword
          send_data(render({:action => "invoice", :layout => false }), :filename => "#{filename}-invoice.doc", :type => "application/msword") 
        }
        format.html {
          render :action => "invoice", :layout => false
        }
      end
    else
      render :action => "document_render_error"
    end

  end
end
