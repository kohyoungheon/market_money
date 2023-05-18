require 'rails_helper'

RSpec.describe Atm do 
  it 'exists' do
    attrs = {
      id: nil,
      poi: {name: "test atm"},
      address: {:freeformAddress=>"164 South Main Street, Amherst, VA 24521"},
      position: {:lat=>123.123, :lon=>12.233},
      dist: 12234.432
    }

    test_atm = Atm.new(attrs)

    expect(test_atm).to be_a(Atm)
    expect(test_atm.id).to eq(nil)
    expect(test_atm.name).to eq("test atm")
    expect(test_atm.address).to eq("164 South Main Street, Amherst, VA 24521")
    expect(test_atm.lat).to eq(123.123)
    expect(test_atm.lon).to eq(12.233)
    expect(test_atm.distance).to eq(12234.432)
  end
end