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

  def search
    if params[:state].nil? && params[:city].nil? && params[:name].nil?
      render json: ErrorSerializer.new(params).invalid_params_error, status: :unprocessable_entity
      return
    end
  
    if params[:city].present? && params[:name].nil? && params[:state].nil?
      render json: ErrorSerializer.new(params).invalid_params_error, status: :unprocessable_entity
      return
    end
  
    if params[:city].present? && params[:name].present? && params[:state].nil?
      render json: ErrorSerializer.new(params).invalid_params_error, status: :unprocessable_entity
      return
    end
  
    markets = Market.search_by_params(params)
    render json: MarketSerializer.new(markets), status: :ok
  end

  def nearest_atms
    
  end
end