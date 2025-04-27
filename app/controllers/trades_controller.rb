# frozen_string_literal: true

class TradesController < ApplicationController
  before_action(:authenticate_user!)

  def chart_data
    trades = latest_trades.reverse.map do |trade|
      [trade.formatted_timestamp, trade.price.to_f]
    end.transpose
    labels, values = trades
    render(
      json: {
        labels: labels || [],
        values: values || []
      }
    )
  end

  private

  def latest_trades
    trades = Trade.order(timestamp: :desc)
    trades = trades.where(stock_symbol: params[:stock_symbol]) if params[:stock_symbol].present?
    trades.limit(50)
  end
end
