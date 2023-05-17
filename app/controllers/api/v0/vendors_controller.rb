class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by(id: params[:market_id])
    if market.nil?
      render json: ErrorSerializer.new(market).market_show_error(params[:market_id]), status: :not_found
    else
      render json: VendorSerializer.new(market.vendors)
    end
  end

  def show
    vendor = Vendor.find_by(id: params[:id])
    if vendor.nil?
      render json: ErrorSerializer.new(vendor).vendor_show_error(params[:id]), status: :not_found
    else
      render json: VendorSerializer.new(vendor)
    end
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: ErrorSerializer.new(vendor).vendor_error, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find_by(id: params[:id])
    if vendor.nil?
      render json: ErrorSerializer.new(vendor).vendor_show_error(params[:id]), status: :not_found
    elsif vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor)
    else
      render json: ErrorSerializer.new(vendor).vendor_error, status: :bad_request
    end
  end
  
  private
  
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end