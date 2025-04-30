# frozen_string_literal: true

if Rails.env.development?
  user = User.find_or_create_by!(name: "Joe Market Watcher", email: "joe@mw.com") do |new_user|
    new_user.password = "Mw6731566"
    new_user.password_confirmation = "Mw6731566"
    puts("Created user: #{new_user.name}")
  end

  user.trade_channels.find_or_create_by!(stock_symbol: Trade::STOCK_SYMBOL_AAPL)

  puts("Seeding complete.")
else
  puts("Skipping seeding in non-development environment.")
end
