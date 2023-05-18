class MarketVendorSerializer
  include JSONAPI::Serializer
  attributes :market_id, :vendor_id

  def create_message
    json = 
    {
      "message": "Successfully added vendor to market"
    }
  end
end
