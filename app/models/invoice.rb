class Invoice < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billable_entity_id :integer, {:null => false}
    billable_entity_type :string, {:limit => 32, :null => false}
    closed :boolean
    timestamps
  end

  index [:billable_period_id, :billable_entity_id, :billable_entity_type], {:unique => true, :name => 'invoices_uk1'}

  belongs_to :billable_period
  belongs_to :customer
  belongs_to :partner

  has_many :invoice_details

  ################################################################################

  def generate
    "<a href=\"/document_generators/invoice/#{id}\">generate invoice</a>"
  end

  ################################################################################

  def billing_details
    case billable_entity_type
    when 'partner'
      BillingDetail.find(:all, :conditions => {:partner_id => partner_id,
                           :billable_period_id => billable_period_id})
    else
      BillingDetail.find(:all, :conditions => {:customer_id => customer_id,
                           :billable_period_id => billable_period_id})
    end
  end

  ################################################################################

  ################################################################################

  def name
    ret = "#{self.send(billable_entity_type.to_sym).send(:name)} - #{billable_period.name}"

    ret += "(p)" if billable_entity_type.match /partner/
    ret
  end

  ################################################################################

  def billable_entity_class
    billable_entity_type.classify.constantize
  end

  ################################################################################

  def billable_entity
    billable_entity_class.find(billable_entity_id)
  end

  def year
    billable_period.year
  end
  
  def month
    billable_period.month
  end

  ################################################################################

  def closed_month?
    closed
  end

  # --- Permissions --- #

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
