class HoboMigration1 < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.float    :monthly_salary
      t.text     :name
      t.float    :monthly_cost
      t.text     :type
      t.text     :title
      t.datetime :start_dt
      t.datetime :end_dt
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :users do |t|
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :name
      t.string   :email_address
      t.boolean  :administrator, :default => false
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "active"
      t.datetime :key_timestamp
    end
    add_index :users, [:state]
  end

  def self.down
    # Could not dump table "x" because of following ActiveRecord::StatementInvalid
    #   PGError: ERROR:  could not identify an ordering operator for type int2vector
    #HINT:  Use an explicit ordering operator or modify the query.
#     :            SELECT distinct i.relname, d.indisunique, d.indkey, t.oid
#                FROM pg_class t, pg_class i, pg_index d
#              WHERE i.relkind = 'i'
#                AND d.indexrelid = i.oid
#                AND d.indisprimary = 'f'
#                AND t.oid = d.indrelid
#                AND t.relname = 'x'
#                AND i.relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname IN ('$user','public') )
#             ORDER BY i.relname

    drop_table :employees
    drop_table :users
  end
end
