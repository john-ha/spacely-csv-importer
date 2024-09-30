module PropertiesHelper
  # Returns the options for the property type select
  # Example: [["Appartment", "appartment"], ["Mansion", "mansion"], ["House", "house"]]
  # @return [Array<Array<String, String>>]
  def property_type_options
    Property.property_types.map do |key, value|
      [key.humanize, key]
    end
  end
end
