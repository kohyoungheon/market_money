class AtmFacade
  attr_reader :search_results

  def initialize(object)
    @object= object
  end

  def nearest_atms
    json = service.get_nearest_atms(@object)
    json[:results].map do |atm_data|
      Atm.new(atm_data)
    end
  end

  private
  def service
    @_service ||= AtmService.new
  end
end