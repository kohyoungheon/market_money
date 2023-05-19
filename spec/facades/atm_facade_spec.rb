require 'rails_helper'

RSpec.describe AtmFacade do
  describe '#nearest_atms' do
    it 'returns nearest atms based on market lat/lon' ,:vcr do
      market_1 = Market.create(name: "Denver Market", street: "123 Market St", city: "Denver", county: "Denver", state: "Colorado", zip: "80202", lat: "35.07904", lon: "-106.60068")
      facade = AtmFacade.new(market_1)
      expect(facade.nearest_atms).to be_an(Array)
    end
  end
end