require "rails_helper"

describe MarketVendor, type: :model do
  describe "relationships" do
    it {should belong_to :market}
    it {should belong_to :vendor}
  end

  describe "validations" do
    it { should validate_numericality_of :market_id}
    it { should validate_numericality_of :vendor_id}
  end
end