# frozen_string_literal: true

require("rails_helper")

RSpec.describe("shared/_flash_messages") do
  context("when flash[:alert] is set") do
    it("renders a flash alert") do
      flash[:alert] = "Something went wrong."
      render(partial: "shared/flash_messages")
      expect(rendered).to(have_css(".flash.bg-red-100", text: "Something went wrong."))
    end
  end

  context("when flash[:notice] is set") do
    it("renders a flash notice") do
      flash[:notice] = "You’ve successfully logged in."
      render(partial: "shared/flash_messages")
      expect(rendered).to(have_css(".flash.bg-green-100", text: "You’ve successfully logged in."))
    end
  end

  context("when no flash messages are set") do
    it("does not render anything") do
      render(partial: "shared/flash_messages")
      expect(rendered).to(be_empty)
    end
  end
end
