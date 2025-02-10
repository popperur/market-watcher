# frozen_string_literal: true

require("rails_helper")

RSpec.describe("Trades") do
  describe("GET /trades/chart_data") do
    context("when user is signed in") do
      let(:user) { create(:user) }
      let!(:apple_trades) { create_list(:trade, 3, stock_symbol: "AAPL") }
      let!(:oracle_trades) { create_list(:trade, 2, stock_symbol: "ORCL") }

      before do
        sign_in(user)
      end

      context("when stock_symbol is provided") do
        it("returns a successful response") do
          get("/trades/chart_data", params: { stock_symbol: "AAPL" })
          expect(response).to(have_http_status(:ok))
        end

        it("returns trades filtered by stock_symbol") do
          get("/trades/chart_data", params: { stock_symbol: "AAPL" })
          json_response = response.parsed_body
          expect(json_response["values"].size).to(eq(3)) # Only AAPL trades
        end
      end

      context("when stock_symbol is not provided") do
        it("returns a successful response") do
          get("/trades/chart_data")
          expect(response).to(have_http_status(:ok))
        end

        it("returns the trades for all symbols") do
          get("/trades/chart_data")
          json_response = response.parsed_body
          expect(json_response["values"].size).to(eq(5)) # 3 AAPL + 2 ORCL trades
        end
      end
    end

    context("when user is not signed in") do
      it("redirects to sign in page") do
        get("/trades/chart_data")
        expect(response).to(redirect_to(new_user_session_path))
      end
    end
  end
end
