class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    market = Market.find_by(id: params[:id])
    if market.nil?
      render json: ErrorSerializer.new(market).market_show_error(params[:id]), status: :not_found
    else
      render json: MarketSerializer.new(market)
    end
  end


end