# frozen_string_literal: true

require("rails_helper")

RSpec.describe("/") do
  describe("GET /index") do
    context("when user is signed in") do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it("returns a successful response") do
        get("/")
        expect(response).to(have_http_status(:ok))
      end
    end

    context("when user is not signed in") do
      it("redirects to sign in page") do
        get("/")
        expect(response).to(redirect_to(new_user_session_path))
      end
    end
  end
end
