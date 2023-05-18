require 'rails_helper'

describe "Market API" do
  describe "1. Get All Markets" do
    it "happy path" do
      create_list(:market, 3)
      get '/api/v0/markets'
  
      expect(response).to be_successful
      markets = JSON.parse(response.body, symbolize_names: true)
  
      expect(markets[:data].count).to eq(3)
  
      markets.each do |market|
        expect(market[1][0][:attributes]).to have_key(:name)
        expect(market[1][0][:attributes][:name]).to be_an(String)
  
        expect(market[1][0][:attributes]).to have_key(:street)
        expect(market[1][0][:attributes][:street]).to be_an(String)
  
        expect(market[1][0][:attributes]).to have_key(:city)
        expect(market[1][0][:attributes][:city]).to be_an(String)

        expect(market[1][0][:attributes]).to have_key(:county)
        expect(market[1][0][:attributes][:county]).to be_an(String)

        expect(market[1][0][:attributes]).to have_key(:state)
        expect(market[1][0][:attributes][:state]).to be_an(String)

        expect(market[1][0][:attributes]).to have_key(:zip)
        expect(market[1][0][:attributes][:zip]).to be_an(String)

        expect(market[1][0][:attributes]).to have_key(:lat)
        expect(market[1][0][:attributes][:lat]).to be_an(String)

        expect(market[1][0][:attributes]).to have_key(:lon)
        expect(market[1][0][:attributes][:lon]).to be_an(String)

        expect(market[1][0][:attributes]).to have_key(:vendor_count)
        expect(market[1][0][:attributes][:vendor_count]).to be_an(Integer)

      end
    end
  end

  describe "2. Get One Market" do
    it "happy path" do
      market_1 = create(:market)
  
      get "/api/v0/markets/#{market_1.id}"
  
      market = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful

      expect(market[:data]).to have_key(:id)
      expect(market[:data][:id]).to be_an(String)
      expect(market[:data][:id]).to eq(market_1.id.to_s)

      expect(market[:data]).to have_key(:type)
      expect(market[:data][:type]).to be_an(String)

      expect(market[:data]).to have_key(:attributes)
      expect(market[:data][:attributes]).to be_an(Hash)

      expect(market[:data][:attributes]).to have_key(:name)
      expect(market[:data][:attributes][:name]).to be_an(String)
      expect(market[:data][:attributes][:name]).to eq(market_1.name)

      expect(market[:data][:attributes]).to have_key(:street)
      expect(market[:data][:attributes][:street]).to be_an(String)
      expect(market[:data][:attributes][:street]).to eq(market_1.street)

      expect(market[:data][:attributes]).to have_key(:city)
      expect(market[:data][:attributes][:city]).to be_an(String)
      expect(market[:data][:attributes][:city]).to eq(market_1.city)

      expect(market[:data][:attributes]).to have_key(:county)
      expect(market[:data][:attributes][:county]).to be_an(String)
      expect(market[:data][:attributes][:county]).to eq(market_1.county)

      expect(market[:data][:attributes]).to have_key(:state)
      expect(market[:data][:attributes][:state]).to be_an(String)
      expect(market[:data][:attributes][:state]).to eq(market_1.state)

      expect(market[:data][:attributes]).to have_key(:zip)
      expect(market[:data][:attributes][:zip]).to be_an(String)
      expect(market[:data][:attributes][:zip]).to eq(market_1.zip)

      expect(market[:data][:attributes]).to have_key(:lat)
      expect(market[:data][:attributes][:lat]).to be_an(String)
      expect(market[:data][:attributes][:lat]).to eq(market_1.lat)

      expect(market[:data][:attributes]).to have_key(:lon)
      expect(market[:data][:attributes][:lon]).to be_an(String)
      expect(market[:data][:attributes][:lon]).to eq(market_1.lon)

      expect(market[:data][:attributes]).to have_key(:vendor_count)
      expect(market[:data][:attributes][:vendor_count]).to be_an(Integer)
      expect(market[:data][:attributes][:vendor_count]).to eq(market_1.vendors.count)

    end

    it "sad path" do
      get "/api/v0/markets/9999999999"

      error = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not(be_successful)

      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to be_an(String)
      expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=9999999999")
    end
  end

  describe "10. Search Markets by state, city, and/or name" do
    it "happy path" do
      market_1 = Market.create!(name: "Denver Market", street: "123 Market St", city: "Denver", county: "Denver", state: "Colorado", zip: "80202", lat: "39.750783", lon: "-104.996439")
      market_2 = Market.create!(name: "Boulder Market", street: "123 Market St", city: "Boulder", county: "Boulder", state: "Colorado", zip: "80301", lat: "40.014984", lon: "-105.270546")
      market_3 = Market.create!(name: "Nob hill", street: "123 Market St", city: "Albuquerque", county: "Boulder", state: "New Mexico", zip: "80301", lat: "40.014984", lon: "-105.270546")

      get '/api/v0/markets/search?city=Albuquerque&state=New Mexico&name=Nob hill'

      expect(response).to be_successful

      market = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful
    
      expect(market[:data][0]).to have_key(:id)
      expect(market[:data][0][:id]).to be_an(String)
      expect(market[:data][0][:id]).to eq(market_3.id.to_s)

      expect(market[:data][0]).to have_key(:type)
      expect(market[:data][0][:type]).to be_an(String)

      expect(market[:data][0]).to have_key(:attributes)
      expect(market[:data][0][:attributes]).to be_an(Hash)

      expect(market[:data][0][:attributes]).to have_key(:name)
      expect(market[:data][0][:attributes][:name]).to be_an(String)
      expect(market[:data][0][:attributes][:name]).to eq(market_3.name)

      expect(market[:data][0][:attributes]).to have_key(:street)
      expect(market[:data][0][:attributes][:street]).to be_an(String)
      expect(market[:data][0][:attributes][:street]).to eq(market_3.street)

      expect(market[:data][0][:attributes]).to have_key(:city)
      expect(market[:data][0][:attributes][:city]).to be_an(String)
      expect(market[:data][0][:attributes][:city]).to eq(market_3.city)

      expect(market[:data][0][:attributes]).to have_key(:county)
      expect(market[:data][0][:attributes][:county]).to be_an(String)
      expect(market[:data][0][:attributes][:county]).to eq(market_3.county)

      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to be_an(String)
      expect(market[:data][0][:attributes][:state]).to eq(market_3.state)

      expect(market[:data][0][:attributes]).to have_key(:zip)
      expect(market[:data][0][:attributes][:zip]).to be_an(String)
      expect(market[:data][0][:attributes][:zip]).to eq(market_3.zip)

      expect(market[:data][0][:attributes]).to have_key(:lat)
      expect(market[:data][0][:attributes][:lat]).to be_an(String)
      expect(market[:data][0][:attributes][:lat]).to eq(market_3.lat)

      expect(market[:data][0][:attributes]).to have_key(:lon)
      expect(market[:data][0][:attributes][:lon]).to be_an(String)
      expect(market[:data][0][:attributes][:lon]).to eq(market_3.lon)

      expect(market[:data][0][:attributes]).to have_key(:vendor_count)
      expect(market[:data][0][:attributes][:vendor_count]).to be_an(Integer)
      expect(market[:data][0][:attributes][:vendor_count]).to eq(market_3.vendors.count)
    end

    describe "sad path" do
      it "cant get results with only city" do
        get '/api/v0/markets/search?city=Albuquerque'
  
        error = JSON.parse(response.body, symbolize_names: true)
        expect(response).to_not be_successful
        expect(error[:errors][0]).to have_key(:detail)
        expect(error[:errors][0][:detail]).to be_an(String)
        expect(error[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      end

      it "cant get results with city and name" do
        get '/api/v0/markets/search?city=Albuquerque&name=Nob hill'

        error = JSON.parse(response.body, symbolize_names: true)
        expect(response).to_not be_successful
        expect(error[:errors][0]).to have_key(:detail)
        expect(error[:errors][0][:detail]).to be_an(String)
        expect(error[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      end
    end
  end

  describe "11. Get Cash Dispensers Near a Market" do
    market_1 = Market.create!(name: "Denver Market", street: "123 Market St", city: "Denver", county: "Denver", state: "Colorado", zip: "80202", lat: "37.583311", lon: "-79.048573")

    it "happy path" do

      get "/api/v0/markets/#{market_1.id}/nearest_atms"

    end
    it "sad path" do

    end
  end
end