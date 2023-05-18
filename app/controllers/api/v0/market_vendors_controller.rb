class Api::V0::MarketVendorsController < ApplicationController
  def create
    vendor = Vendor.find_by(id: market_vendor_params[:vendor_id])
    market = Market.find_by(id: market_vendor_params[:market_id])
    
    if vendor && market
      market_vendor = MarketVendor.new(market_vendor_params)
      if market_vendor.save
        render json: MarketVendorSerializer.new(market_vendor).create_message, status: :created
      else
        render json: ErrorSerializer.new(market_vendor).market_vendor_error, status: :bad_request
      end
    else
      render json: ErrorSerializer.new(vendor).doesnt_exist_error, status: :bad_request
    end
  end
  
  def destroy
    vendor = Vendor.find_by(id: market_vendor_params[:vendor_id])
    market = Market.find_by(id: market_vendor_params[:market_id])

    if vendor && market
      market_vendor = MarketVendor.find_by(market_id: market.id, vendor_id: vendor.id).destroy
      render json: market_vendor.destroy, status: :no_content
    else
      render json: ErrorSerializer.new(market_vendor_params).no_vendor_market_association_error, status: :bad_request
    end
  end

  private
  
  def market_vendor_params
    params.require(:vendor).permit(:market_id, :vendor_id)
  end
end