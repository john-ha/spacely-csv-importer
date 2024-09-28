class PropertyDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def full_address
    [object.address, object.room_number].compact.join(" ")
  end

  def area_square_meters
    "#{object.area_square_meters} m²" if object.area_square_meters.present?
  end

  def rent
    "#{object.rent} 円" if object.rent.present?
  end

  def property_type
    object.property_type.humanize
  end
end
