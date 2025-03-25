# frozen_string_literal: true

source("https://rubygems.org")

gem("bootsnap", require: false)
gem("chartkick")
gem("devise", "~> 4.9")
gem("importmap-rails")
gem("kamal", require: false)
gem("pg", "~> 1.1")
gem("propshaft")
gem("puma", ">= 5.0")
gem("rails", "~> 8.0.0")
gem("redis")
gem("stimulus-rails")
gem("tailwindcss-rails")
gem("thruster", require: false)
gem("turbo-rails")
gem("tzinfo-data", platforms: %i[windows jruby])
gem("websocket-client-simple")

group(:development, :test) do
  gem("brakeman", require: false)
  gem("factory_bot_rails")
  gem("faker")
  gem("pry-byebug")
  gem("rspec-rails", "~> 7.0.0")
  gem("rubocop", require: false)
  gem("rubocop-capybara", require: false)
  gem("rubocop-factory_bot", require: false)
  gem("rubocop-performance", require: false)
  gem("rubocop-rails", require: false)
  gem("rubocop-rspec", require: false)
  gem("rubocop-rspec_rails", require: false)
end

group(:development) do
  gem("web-console")
end

group(:test) do
  gem("capybara")
  gem("selenium-webdriver")
  gem("shoulda-matchers")
end
