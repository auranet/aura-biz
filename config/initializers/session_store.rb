# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_AuraBiz_session',
  :secret      => '23fdf86464b47f07e880c1a752cda45a7d5a66653da336a706d764157570459e777fc08bd0f63436d3c19d321e6c88f972c636e695d7c0e62458ca4e8ab5575a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
