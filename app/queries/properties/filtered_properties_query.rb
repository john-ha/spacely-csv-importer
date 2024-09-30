module Properties
  class FilteredPropertiesQuery < Query
    def initialize(scope = Property.all)
      @scope = scope
    end

    def call(search: nil, property_type: nil, page: 1, per: 10)
      query = @scope.ransack({
        external_id_or_name_or_address_or_room_number_cont: search,
        property_type_eq: Property.property_types[property_type]
      })
      scope = query.result.order(:external_id).page(page).per(per)

      [scope, query]
    end
  end
end
