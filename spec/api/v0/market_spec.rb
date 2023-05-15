require 'rails_helper'

describe "Market API" do
  it "sends a list of books" do

    markets = create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful
  end
end