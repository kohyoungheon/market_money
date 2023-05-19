require 'rails_helper'

describe AtmService do
  describe "instance methods" do
    it "get_nearest_atms" do
      market_1 = Market.create(name: "Denver Market", street: "123 Market St", city: "Denver", county: "Denver", state: "Colorado", zip: "80202", lat: "37.583311", lon: "-79.048573")
      atms = AtmService.new.get_nearest_atms(market_1)

      expect(atms).to be_a Hash
      expect(atms[:results]).to be_an Array
      expect(atms[:results].first[:dist]).to be_a Float
      expect(atms[:results].first[:poi][:name]).to be_a String
      expect(atms[:results].first[:address][:freeformAddress]).to be_a String
      expect(atms[:results].first[:position][:lat]).to be_a Float
      expect(atms[:results].first[:position][:lon]).to be_a Float
    end
  end
end