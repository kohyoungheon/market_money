require 'rails_helper'

describe "Vendor API" do
  describe "3. Get All Vendors for a Market" do
    it "happy path" do
      @market = create(:market)
      @vendor = create(:vendor)
      @vendor_2 = create(:vendor)
      @market.vendors << @vendor
      @market.vendors << @vendor_2

      get "/api/v0/markets/#{@market.id}/vendors"
      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(vendors[:data].count).to eq(2)

      vendors.each do |vendor|
        expect(vendor[1][0][:attributes]).to have_key(:name)
        expect(vendor[1][0][:attributes][:name]).to be_an(String)

        expect(vendor[1][0][:attributes]).to have_key(:description)
        expect(vendor[1][0][:attributes][:description]).to be_an(String)

        expect(vendor[1][0][:attributes]).to have_key(:contact_name)
        expect(vendor[1][0][:attributes][:contact_name]).to be_an(String)
        
        expect(vendor[1][0][:attributes]).to have_key(:contact_phone)
        expect(vendor[1][0][:attributes][:contact_phone]).to be_an(String)

        expect(vendor[1][0][:attributes]).to have_key(:credit_accepted)
        expect(vendor[1][0][:attributes][:credit_accepted]).to eq(true).or eq(false)
      end
    end

    it "sad path" do
      get "/api/v0/markets/9999999999/vendors"

      error = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not(be_successful)

      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to be_an(String)
      expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=9999999999")
    end
  end

  describe "4. Get One Vendor" do
    it "happy path" do
      vendor = create(:vendor)
      get "/api/v0/vendors/#{vendor.id}"
      parsed = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(parsed[:data]).to have_key(:id)
      expect(parsed[:data][:id]).to be_an(String)
      expect(parsed[:data][:id]).to eq(vendor.id.to_s)

      expect(parsed[:data]).to have_key(:type)
      expect(parsed[:data][:type]).to be_an(String)

      expect(parsed[:data]).to have_key(:attributes)
      expect(parsed[:data][:attributes]).to be_an(Hash)

      expect(parsed[:data][:attributes]).to have_key(:name)
      expect(parsed[:data][:attributes][:name]).to be_an(String)
      expect(parsed[:data][:attributes][:name]).to eq(vendor.name)

      expect(parsed[:data][:attributes]).to have_key(:description)
      expect(parsed[:data][:attributes][:description]).to be_an(String)
      expect(parsed[:data][:attributes][:description]).to eq(vendor.description)

      expect(parsed[:data][:attributes]).to have_key(:contact_name)
      expect(parsed[:data][:attributes][:contact_name]).to be_an(String)
      expect(parsed[:data][:attributes][:contact_name]).to eq(vendor.contact_name)  
      
      expect(parsed[:data][:attributes]).to have_key(:contact_phone)
      expect(parsed[:data][:attributes][:contact_phone]).to be_an(String)
      expect(parsed[:data][:attributes][:contact_phone]).to eq(vendor.contact_phone)

      expect(parsed[:data][:attributes]).to have_key(:credit_accepted)
      expect(parsed[:data][:attributes][:credit_accepted]).to eq(true).or eq(false)
      expect(parsed[:data][:attributes][:credit_accepted]).to eq(vendor.credit_accepted)
    end

    it "sad path" do
      get "/api/v0/vendors/9999999999"

      error = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not(be_successful)

      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to be_an(String)
      expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=9999999999")
    end
  end

  describe "5. Create a Vendor" do
    it "happy path" do
      vendor_params = ({
        "name": "Buzzy Bees",
        "description": "local honey and wax products",
        "contact_name": "Berly Couwer",
        "contact_phone": "8389928383",
        "credit_accepted": false
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last

      expect(response).to be_successful

      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it "sad path" do
      vendor_params = ({
        "name": "",
        "description": "",
        "contact_name": "",
        "contact_phone": "",
        "credit_accepted": ""
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      error = JSON.parse(response.body, symbolize_names: true)

      
      expect(response).to_not(be_successful)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to be_an(String)
      expect(error[:errors][0][:detail]).to eq("Name can't be blank, Description can't be blank, Contact name can't be blank, Contact phone can't be blank, and Credit accepted must be a boolean")
    end
  end

  describe "6. Update a Vendor" do
    it "happy path" do
      vendor_1 = create(:vendor)
      previous_name = Vendor.last.name
      previous_contact_name = Vendor.last.contact_name
      vendor_params = { name: "World's Best Vendor", contact_name: "Kimberly Couwer" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      patch "/api/v0/vendors/#{vendor_1.id}", headers: headers, params: JSON.generate({vendor: vendor_params})

      vendor_1.reload
      expect(response).to be_successful
      expect(vendor_1.name).to_not eq(previous_name)
      expect(vendor_1.contact_name).to_not eq(previous_contact_name)
      expect(vendor_1.name).to eq("World's Best Vendor")
      expect(vendor_1.contact_name).to eq("Kimberly Couwer")
    end

    describe "sad path" do
      it "id is invalid" do
        vendor_params = { name: "World's Best Vendor", contact_name: "Kimberly Couwer" }
        headers = {"CONTENT_TYPE" => "application/json"}
        patch "/api/v0/vendors/99999999", headers: headers, params: JSON.generate({vendor: vendor_params})
        error = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not(be_successful)

        expect(error[:errors][0]).to have_key(:detail)
        expect(error[:errors][0][:detail]).to be_an(String)
        expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=99999999")
      end

      it "field cannot be blank" do
        vendor_1 = create(:vendor)
        previous_name = Vendor.last.name
        previous_contact_name = Vendor.last.contact_name

        vendor_params = { name: "", contact_name: "", credit_accepted: "" }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v0/vendors/#{vendor_1.id}", headers: headers, params: JSON.generate({vendor: vendor_params})
        error = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not(be_successful)
        expect(error[:errors][0]).to have_key(:detail)
        expect(error[:errors][0][:detail]).to be_an(String)
        expect(error[:errors][0][:detail]).to eq("Name can't be blank, Contact name can't be blank, and Credit accepted must be a boolean")
      end
    end
  end

  describe "7. Delete a Vendor" do
    it "happy path" do
      vendor = create(:vendor)

      expect(Vendor.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(Vendor.count).to eq(0)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "sad path" do
      delete "/api/v0/vendors/99999999"
      error = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not(be_successful)

      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to be_an(String)
      expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=99999999")
    end
  end

end