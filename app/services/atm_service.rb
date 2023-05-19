require 'faraday'

class AtmService
  
  def get_nearest_atms(object)
    get_url("/search/2/categorySearch/atm.json?key=#{ENV['TOMTOM_API_KEY']}&lat=#{object.lat}&lon=#{object.lon}")
  end

  private
  def conn
    Faraday.new(url: "https://api.tomtom.com")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end