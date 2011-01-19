class BillablePeriod < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    month :integer
    year  :integer
    locked :boolean
    last_maintenace_dt :timestamp
    locked_dt :timestamp
    timestamps
  end

  has_many :task_hours
  has_many :billing_details
  has_many :invoices

  def num_billing_details
    billing_details.length
  end

  def num_task_hours
    task_hours.length
  end

  def num_invoices
    invoices.length
  end

  def effective_dt
    ActiveRecord::Base.db_date(month,1,year) # defined in the ckuru_extensions plugin
  end

  def name 
    "#{month}/#{year}"
  end

  ################################################################################

  def maintenance
    raise "month is closed" if locked

    transaction do
      calculate_billing_detail
      generate_invoices
    end

    self.last_maintenace_dt = Time.now
    self.save!

  end


  ################################################################################

  def delete_billing_detail_for_this_period
    billing_details.each do |bd|
      BillingDetail.delete(bd.id)
    end
  end

  ################################################################################

  def calculate_billing_detail
    delete_billing_detail_for_this_period

    task_hours.each do |tt|
      tt.generate_billing_detail
    end

    ckebug 0, "generating billing detail for #{self}"
#     PurchaseOrder.all_for_period(:invoice_month_id => invoice_month_id).each do |po|
#       ckebug 0, "generating billing detail for po #{po.to_label}"
#       po.generate_billing_detail(self)
#     end
  end

  ################################################################################

  #   def delete_payable_detail_for_this_month
#     self.connection.execute("delete from payable_detail where month = #{month} and year = #{year}")
#   end

  ################################################################################

  def generate_invoices
    raise "cannot generate invoices on locked month" if locked

    all = []
    Customer.find_all.each {|c|
      all.push [c,nil,:customer,"customer_id","f"]
    }
    Partner.find_all.each {|c|
      all.push [nil,c,:partner,"partner_id","t"]
    }

    all.each do |invoiceable|
      customer,partner,type,fk,invoice_partner = invoiceable
      record = customer || partner

      ckebug 0, (sql = "select sum(billable_amount) from billing_details where billable_period_id = #{id} and #{fk} = #{record.id} and invoice_partner = '#{invoice_partner}'")
      amt = connection.execute(sql)[0]["sum"]

      next if amt.nil? or amt.to_f <= 0 # don't bother creating zero invoices

      i = nil
      unless i = Invoice.find_only_one(:all, 
                                       :conditions => {
                                         :billable_period_id => id,
                                         :billable_entity_type => type.to_s,
                                         :billable_entity_id => record.id}
                                       )
        begin
          i = Invoice.create(:billable_period => self,
                             :customer => customer,
                             :billable_entity_id => record.id,
                             :billable_entity_type => type.to_s,
                             :partner => partner)
        rescue Exception => e
          ckebug 0, e
        end

      end

      ckebug 0, i.inspect

      ckebug 0, (sql = "delete from invoice_details where invoice_id = #{i.id} and invoice_detail_type_id = (select invoice_detail_type_id from invoice_detail_types where name = 'I') and (locked is null or locked = 't')")
      connection.execute(sql)

      detail_type = InvoiceDetailType.find_only_one(:all, {:conditions => {:name => 'I'}})

#      begin
        id = InvoiceDetail.create(:invoice_detail_type => detail_type,
                                  :invoice => i,
                                  :amount => amt,
                                  :post_dt => Time.now) # could fail on a locked row.
        ckebug 0, id.inspect        
#      end
    end
  end

  # --- permissions --- #

  ################################################################################

  def create_permitted?
    acting_user.administrator?
  end

  ################################################################################

  def update_permitted?
    acting_user.administrator?
  end

  ################################################################################

  def destroy_permitted?
    acting_user.administrator?
  end

  ################################################################################

  def view_permitted?(field)
    acting_user.administrator?
  end

end
