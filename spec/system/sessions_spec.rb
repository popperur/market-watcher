# frozen_string_literal: true

require("rails_helper")

RSpec.describe("Sessions") do
  let(:user) { create(:user) }

  it("displays the login page correctly") do
    visit(new_user_session_path)
    expect(page).to(
      have_css("h1.logo", text: "Market Watcher")
        .and(have_field("Email"))
        .and(have_field("Password"))
        .and(have_button("Log in"))
    )
  end

  context("when valid credentials are provided") do
    it("allows the user to log in") do
      Capybara.using_session(:valid_user) do
        visit(new_user_session_path)
        fill_in("Email", with: user.email)
        fill_in("Password", with: user.password)
        click_link_or_button("Log in")

        expect(page).to(have_current_path(root_path))
      end
    end
  end

  context("when invalid credentials are provided") do
    it("shows an error") do
      Capybara.using_session(:invalid_user) do
        visit(new_user_session_path)
        fill_in("Email", with: "wrong@example.com")
        fill_in("Password", with: "password")
        click_link_or_button("Log in")

        expect(page).to(have_content("Oops! Your email or password is incorrect."))
      end
    end
  end
end
