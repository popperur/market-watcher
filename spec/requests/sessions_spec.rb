# frozen_string_literal: true

require("rails_helper")

RSpec.describe("Sessions") do
  describe("GET /users/sign_in") do
    it("returns a successful response") do
      get(new_user_session_path)
      expect(response).to(have_http_status(:ok))
    end
  end
end
