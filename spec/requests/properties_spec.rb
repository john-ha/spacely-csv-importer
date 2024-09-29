require "rails_helper"

RSpec.describe "Properties", type: :request do
  describe "GET /properties" do
    let!(:properties) { create_list(:property, 3) }

    it "renders the index template" do
      get properties_index_path

      expect(response).to have_http_status(:ok)

      expect(response.body).to include("Properties (#{Property.count})")
      expect(response.body).to include("All the imported properties.")

      properties.map(&:decorate).each do |property|
        expect(response.body).to include(property.external_id)
        expect(response.body).to include(property.name)
        expect(response.body).to include(property.full_address)
        expect(response.body).to include(property.formatted_area_square_meters)
        expect(response.body).to include(property.formatted_rent)
        expect(response.body).to include(property.formatted_property_type)
      end
    end
  end
end
