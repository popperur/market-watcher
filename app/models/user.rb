# frozen_string_literal: true

class User < ApplicationRecord
  has_many(:trade_channels, dependent: :destroy)

  validates(:name, presence: true)

  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable)
end
