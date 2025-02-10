# frozen_string_literal: true

module SystemHelpers
  def system_sign_in(user)
    visit(new_user_session_path)
    fill_in("Email", with: user.email)
    fill_in("Password", with: user.password)
    click_link_or_button("Log in")
  end
end

RSpec.configure do |config|
  config.include(SystemHelpers, type: :system)
  # Set selenium_chrome_headless as the default driver for all system tests
  config.before(:each, type: :system) do
    driven_by(:selenium_chrome_headless)
  end
end
