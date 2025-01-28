# frozen_string_literal: true

class CreateTrades < ActiveRecord::Migration[8.0]
  def change
    create_table(:trades) do |t|
      t.string(:stock_symbol, null: false, index: true)
      t.string(:exchange_name, null: false)
      t.string(:exchange_trade_id, null: false)
      t.decimal(:price, precision: 10, scale: 2, null: false)
      t.integer(:quantity, null: false)
      t.datetime(:timestamp, null: false, index: true)

      t.timestamps
    end
  end
end
