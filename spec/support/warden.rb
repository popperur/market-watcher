# frozen_string_literal: true

RSpec.configure do |config|
  config.include(Warden::Test::Helpers)
  config.after(type: :system) { Warden.test_reset! }
end
