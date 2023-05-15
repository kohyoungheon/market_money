class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market_id, numericality: true
  validates :vendor_id, numericality: true
end