# frozen_string_literal: true

class TradeChannel < ApplicationRecord
  belongs_to(:user)

  validates(:stock_symbol, presence: true, inclusion: { in: Trade::STOCK_SYMBOLS })
end
