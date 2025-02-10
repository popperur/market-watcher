# frozen_string_literal: true

require("rails_helper")

RSpec.describe(User) do
  describe("associations") do
    it { is_expected.to(have_many(:trade_channels).dependent(:destroy)) }
  end

  describe("validations") do
    describe("name") do
      it { is_expected.to(validate_presence_of(:name)) }
    end
  end

  describe("factories") do
    it("has a valid factory") do
      expect(build(:user)).to(be_valid)
    end
  end
end
