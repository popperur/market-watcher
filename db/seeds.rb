# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  user = User.find_or_create_by!(name: "Joe Market Watcher", email: "joe@mw.com") do |user|
    user.password = "Mw6731566"
    user.password_confirmation = "Mw6731566"
    puts("Created user: #{user.name}")
  end

  user.trade_channels.find_or_create_by!(stock_symbol: Trade::STOCK_SYMBOL_AAPL)

  puts("Seeding complete.")
else
  puts("Skipping seeding in non-development environment.")
end
