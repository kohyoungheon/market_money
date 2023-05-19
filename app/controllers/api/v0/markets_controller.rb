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
    state = params[:state]
    city = params[:city]
    name = params[:name]
    
    if state.nil? && city.nil? && name.nil?
      render json: ErrorSerializer.new(params).invalid_params_error, status: :unprocessable_entity
      return
    end
    if city.present? && name.nil? && state.nil?
      render json: ErrorSerializer.new(params).invalid_params_error, status: :unprocessable_entity
      return
    end
    if city.present? && name.present? && state.nil?
      render json: ErrorSerializer.new(params).invalid_params_error, status: :unprocessable_entity
      return
    end
    markets = Market.search_by_params(params)
    render json: MarketSerializer.new(markets), status: :ok
  end

  def nearest_atms
    market = Market.find_by(id: params[:id])
    
    if market.nil?
      render json: ErrorSerializer.new(market).market_show_error(params[:id]), status: :not_found
      return
    end

    facade = AtmFacade.new(market).nearest_atms
    render json: AtmSerializer.new(facade), status: :ok
  end
end