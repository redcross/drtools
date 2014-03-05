# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
DRTools::Application.config.secret_key_base = Rails.env.production? ? ENV['RAILS_SECRET_KEY'] : 'e1a1db19960d910f6bd520f481eec0905f2a8ad26d8b0d8d9a379916f85e77632d78a50391a8a5a637961a486a12bad76347e1aab72045fa6b1daef7a769736d'
