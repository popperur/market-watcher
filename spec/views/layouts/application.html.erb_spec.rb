# frozen_string_literal: true

require("rails_helper")

RSpec.describe("layouts/application") do
  describe("document structure") do
    before do
      allow(view).to(receive(:user_signed_in?).and_return(false))
    end

    it("renders the link for tailwind css") do
      render
      expect(rendered).to(have_css('link[href*="tailwind"][data-turbo-track="reload"]', visible: :hidden))
    end

    it("renders the javascript import maps") do
      render
      expect(rendered).to(have_css('script[type="importmap"][data-turbo-track="reload"]', visible: :hidden))
    end
  end

  context("when the user is signed in") do
    before do
      allow(view).to(receive(:user_signed_in?).and_return(true))
    end

    describe("header") do
      it("renders the logo") do
        render
        expect(rendered).to(have_css("h1.logo", text: "Market Watcher"))
      end

      it("renders the logout button") do
        render
        expect(rendered).to(have_button("Logout", class: "btn-secondary"))
      end
    end

    describe("main") do
      it("renders the main wrapper") do
        render
        expect(rendered).to(have_css("main.flex"))
      end
    end
  end

  context("when the user is not signed in") do
    before do
      allow(view).to(receive(:user_signed_in?).and_return(false))
    end

    describe("main") do
      it("renders the main wrapper") do
        render
        expect(rendered).to(have_css("main.rounded"))
      end
    end
  end
end
