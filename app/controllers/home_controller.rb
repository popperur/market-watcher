# frozen_string_literal: true

class HomeController < ApplicationController
  before_action(:authenticate_user!)
  def index
    @trade_channels = current_user.trade_channels
  end
end
