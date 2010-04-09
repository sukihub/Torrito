# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_torrito_session',
  :secret      => 'a16c74d54e513235467b6ded43ebba4954880170c2717412be2ec4299751a2362f26af1359d92461e38c2c5ea02bd2cd8a5424c05f6c4958e5e8698ba7fac65a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
