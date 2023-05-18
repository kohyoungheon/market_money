require 'rails_helper'

describe "Market Vendor API" do
  describe "8. Create a MarketVendor" do
    it "happy path" do
      market = create(:market)
      vendor = create(:vendor)

      market_vendor_params = ({
        "market_id": "#{market.id}",
        "vendor_id": "#{vendor.id}"
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)
      created_market_vendor = MarketVendor.last

      expect(response).to be_successful
      expect(created_market_vendor.market_id).to eq(market.id)
      expect(created_market_vendor.vendor_id).to eq(vendor.id)
  
    end

    describe "sad path" do
      it "market/vendor id is invalid" do
        market = create(:market)
        vendor = create(:vendor)

        market_vendor_params = ({
          "market_id": "99999",
          "vendor_id": "#{vendor.id}"
          })

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)
        error = JSON.parse(response.body, symbolize_names: true)

      
        expect(response).to_not(be_successful)
        expect(error[:errors][0]).to have_key(:detail)
        expect(error[:errors][0][:detail]).to be_an(String)
        expect(error[:errors][0][:detail]).to eq("Validation failed: Market must exist")
      end

      it "relationship already exists" do
        market = create(:market)
        vendor = create(:vendor)
        market_vendor = MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)

        market_vendor_params = ({
          "market_id": "#{market.id}",
          "vendor_id": "#{vendor.id}"
          })
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not(be_successful)
        expect(error[:errors][0]).to have_key(:detail)
        expect(error[:errors][0][:detail]).to be_an(String)
        expect(error[:errors][0][:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
      end
    end
  end

  describe "9. Delete a MarketVendor" do
    it "happy path" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)

      expect(MarketVendor.last).to eq(market_vendor)

      market_vendor_params = ({
        "market_id": "#{market.id}",
        "vendor_id": "#{vendor.id}"
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

      expect(response).to be_successful
      expect(MarketVendor.last).to eq(nil)
    end

    it "sad path" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)

      market_vendor_params = ({
        "market_id": "99999999",
        "vendor_id": "#{vendor.id}"
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)
      error = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not(be_successful)
  
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to be_an(String)
      expect(error[:errors][0][:detail]).to eq("No MarketVendor with market_id=99999999 AND vendor_id=#{vendor.id} exists")
    end
  end
end