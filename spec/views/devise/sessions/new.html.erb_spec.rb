# frozen_string_literal: true

require("rails_helper")

RSpec.describe("devise/sessions/new") do
  before do
    # extend the view object with the necessary Devise helpers
    view.singleton_class.class_eval do
      def resource = User.new
      def resource_name = :user
      def devise_mapping = Devise.mappings[:user]
    end
  end

  describe("logo") do
    it("renders the page logo") do
      render
      expect(rendered).to(have_css("h1.logo", text: "Market Watcher"))
    end
  end

  describe("login form") do
    it("renders the login form") do
      render
      expect(rendered).to(have_css("form[action='/users/sign_in'][method='post']"))
    end

    it("includes the email field") do
      render
      expect(rendered).to(have_field("user[email]", type: "email"))
    end

    it("includes the password field") do
      render
      expect(rendered).to(have_field("user[password]", type: "password"))
    end

    it("renders the remember me checkbox if rememberable is enabled") do
      allow(view.devise_mapping).to(receive(:rememberable?).and_return(true))
      render
      expect(rendered).to(have_field("user[remember_me]", type: "checkbox"))
    end

    it("has a submit button for logging in") do
      render
      expect(rendered).to(have_button("Log in"))
    end
  end

  describe("flash messages") do
    it("renders flash messages") do
      render
      expect(rendered).to(have_css(".flash-messages"))
    end
  end
end
