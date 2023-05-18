class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  def self.search_by_params(params)
    markets = Market.all
    markets = markets.where(state: params[:state]) if params[:state]
    markets = markets.where(name: params[:name]) if params[:name]
    markets = markets.where(city: params[:city]) if params[:city]
    markets
  end

end