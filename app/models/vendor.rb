class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  validate :credit_accepted_boolean

  private

  def credit_accepted_boolean
    unless credit_accepted == true || credit_accepted == false || credit_accepted.nil?
      errors.add(:credit_accepted, "must be a boolean")
    end
  end

end
