# frozen_string_literal: true

RSpec.configure do |config|
  # Set selenium_chrome_headless as the default driver for all system tests
  config.before(:each, type: :system) do
    driven_by(:selenium_chrome_headless)
  end
end
