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

  
end