class ErrorSerializer
  include JSONAPI::Serializer

  def initialize(error_object)
    @error_object = error_object
  end

  def market_show_error(id)
    json = {"errors": [
      {
          "detail": "Couldn't find Market with 'id'=#{id}"
      }
                      ]
            }

  end

  def vendor_show_error(id)
    json = {"errors": [
      {
          "detail": "Couldn't find Vendor with 'id'=#{id}"
      }
                      ]
            }

  end

  def vendor_error
    json = {"errors": [
      {
          "detail": "#{@error_object.errors.full_messages.to_sentence}"
      }
                      ]
            }
  end

  def market_vendor_error
    json = {"errors": [
          {
              "detail": "Validation failed: Market vendor asociation between market with market_id=#{@error_object.market_id} and vendor_id=#{@error_object.vendor_id} already exists"
          }
                      ]
            }
  end

  def doesnt_exist_error
    if @error_object
      json = {"errors": [
        {
            "detail": "Validation failed: Market must exist"
        }
                    ]
          }
    else
      json = {"errors": [
        {
            "detail": "Validation failed: Vendor must exist"
        }
                    ]
          }
    end
  end

  def no_vendor_market_association_error
    json = {"errors": [
      {
        "detail": "No MarketVendor with market_id=#{@error_object["market_id"]} AND vendor_id=#{@error_object["vendor_id"]} exists"
      }
                      ]
            }
  end

  def invalid_params_error
   json = {
      "errors": [
          {
              "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
          }
                ]
          }
  end
end