# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 201104111007101) do

  create_table "bill_rates", :force => true do |t|
    t.float    "rate",                :default => 0.0
    t.date     "effective_dt"
    t.date     "expiration_dt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.integer  "billable_task_id"
    t.integer  "partner_contract_id"
    t.float    "pay_rate",            :default => 0.0
  end

  add_index "bill_rates", ["billable_task_id"], :name => "index_bill_rates_on_billable_task_id"
  add_index "bill_rates", ["employee_id"], :name => "index_bill_rates_on_employee_id"
  add_index "bill_rates", ["partner_contract_id"], :name => "index_bill_rates_on_partner_contract_id"

  create_table "billable_periods", :force => true do |t|
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked"
    t.datetime "last_maintenace_dt"
    t.datetime "locked_dt"
  end

  create_table "billable_tasks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_contract_id"
    t.boolean  "disabled"
  end

  add_index "billable_tasks", ["partner_contract_id"], :name => "index_billable_tasks_on_partner_contract_id"

  create_table "billing_details", :force => true do |t|
    t.float    "billable_amount",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.integer  "billable_task_id"
    t.integer  "bill_rate_id"
    t.integer  "partner_contract_id"
    t.integer  "partner_id"
    t.integer  "customer_id"
    t.integer  "billable_period_id"
    t.integer  "task_hour_id"
    t.float    "payable_amount"
    t.float    "actual_bill_rate",         :null => false
    t.boolean  "invoice_partner"
    t.float    "billable_hours",           :null => false
    t.float    "pay_rate"
    t.integer  "partner_contract_rate_id"
    t.integer  "employee_task_rate_id"
  end

  add_index "billing_details", ["bill_rate_id"], :name => "index_billing_details_on_bill_rate_id"
  add_index "billing_details", ["billable_period_id"], :name => "index_billing_details_on_billable_period_id"
  add_index "billing_details", ["billable_task_id"], :name => "index_billing_details_on_billable_task_id"
  add_index "billing_details", ["customer_id"], :name => "index_billing_details_on_customer_id"
  add_index "billing_details", ["employee_id"], :name => "index_billing_details_on_employee_id"
  add_index "billing_details", ["partner_contract_id"], :name => "index_billing_details_on_partner_contract_id"
  add_index "billing_details", ["partner_id"], :name => "index_billing_details_on_partner_id"
  add_index "billing_details", ["task_hour_id"], :name => "index_billing_details_on_task_hour_id"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "billing_address"
    t.text     "billing_note"
  end

  create_table "dual", :id => false, :force => true do |t|
    t.integer "x"
  end

  create_table "employee_details", :force => true do |t|
    t.float    "yearly_salary"
    t.string   "title"
    t.float    "cost"
    t.date     "effective_dt"
    t.date     "expiration_dt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.text     "employee_type"
    t.float    "yearly_vacation_days"
    t.float    "yearly_flex_days"
  end

  add_index "employee_details", ["employee_id"], :name => "index_employee_details_on_employee_id"

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "ssn"
    t.date     "employment_start_dt"
    t.date     "employment_end_dt"
  end

  create_table "invoice_detail_types", :force => true do |t|
    t.string   "name",        :limit => 1,   :null => false
    t.string   "description", :limit => 128, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_detail_types", ["name"], :name => "invoice_detail_types_uk1", :unique => true

  create_table "invoice_details", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invoice_detail_type_id"
    t.boolean  "locked"
    t.date     "post_dt"
    t.integer  "invoice_id"
    t.float    "amount",                                 :null => false
    t.string   "notes",                  :limit => 1024
  end

  add_index "invoice_details", ["invoice_detail_type_id"], :name => "index_invoice_details_on_invoice_detail_type_id"
  add_index "invoice_details", ["invoice_id"], :name => "index_invoice_details_on_invoice_id"

  create_table "invoices", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billable_period_id"
    t.integer  "customer_id"
    t.integer  "partner_id"
    t.integer  "billable_entity_id",                    :null => false
    t.string   "billable_entity_type",    :limit => 32, :null => false
    t.boolean  "closed"
    t.text     "po_number"
    t.date     "hard_coded_invoice_date"
  end

  add_index "invoices", ["billable_period_id", "billable_entity_id", "billable_entity_type"], :name => "invoices_uk1", :unique => true
  add_index "invoices", ["billable_period_id"], :name => "index_invoices_on_billable_period_id"
  add_index "invoices", ["customer_id"], :name => "index_invoices_on_customer_id"
  add_index "invoices", ["partner_id"], :name => "index_invoices_on_partner_id"

  create_table "partner_contracts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_id"
    t.integer  "customer_id"
    t.boolean  "invoice_partner"
  end

  add_index "partner_contracts", ["customer_id"], :name => "index_partner_contracts_on_customer_id"
  add_index "partner_contracts", ["partner_id"], :name => "index_partner_contracts_on_partner_id"

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_hours", :force => true do |t|
    t.float    "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.integer  "billable_task_id"
    t.integer  "billable_period_id"
    t.string   "locked",             :limit => 1
  end

  add_index "task_hours", ["billable_period_id"], :name => "index_task_hours_on_billable_period_id"
  add_index "task_hours", ["billable_task_id"], :name => "index_task_hours_on_billable_task_id"
  add_index "task_hours", ["employee_id"], :name => "index_task_hours_on_employee_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
