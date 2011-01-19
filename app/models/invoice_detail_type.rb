class InvoiceDetailType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, {:limit => 1, :null => false, :unique => true}
    description :string, {:limit => 128, :null => false} #, :unique => true}
    timestamps
  end

  index [:name], {:unique => true, :name => 'invoice_detail_types_uk1'}

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

# [['A','Adjustment'  ],
#  ['R','Pre-paid Credit'],
#  ['X','Pre-paid Credit Applied',],
#  ['I','Invoiced Amount'],
#  ['P','Paid'],
#  ['C','Credit']].each do |type,descr|
#   begin
#     InvoiceDetailType.create(:name => type,
#                              :description => descr)
#   rescue
#   end
# end

 
