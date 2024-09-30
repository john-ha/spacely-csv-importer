require "rails_helper"

RSpec.describe "Properties", type: :request do
  describe "GET /properties" do
    let!(:properties) { create_list(:property, 3) }

    context "without any parameters" do
      it "renders the index template" do
        get properties_index_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Properties (3)")
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

    context "with :page and :per parameter" do
      let(:page) { 2 }
      let(:per) { 2 }

      it "renders the index template with paginated properties" do
        get properties_index_path(page:, per:)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Properties (3)")
        expect(response.body).to include("All the imported properties.")

        properties.first(2).map(&:decorate).each do |property|
          expect(response.body).not_to include(property.external_id)
        end

        decorated_property = properties.last.decorate

        expect(response.body).to include(decorated_property.external_id)
        expect(response.body).to include(decorated_property.name)
        expect(response.body).to include(decorated_property.full_address)
        expect(response.body).to include(decorated_property.formatted_area_square_meters)
        expect(response.body).to include(decorated_property.formatted_rent)
        expect(response.body).to include(decorated_property.formatted_property_type)
      end
    end

    context "with :search parameter" do
      let!(:property) { properties.last }
      let(:search) { property.name }

      it "renders the index template with filtered properties" do
        get properties_index_path(search:)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Properties (1)")
        expect(response.body).to include("All the imported properties.")

        properties.first(2).map(&:decorate).each do |property|
          expect(response.body).not_to include(property.external_id)
        end

        decorated_property = property.decorate

        expect(response.body).to include(decorated_property.external_id)
        expect(response.body).to include(decorated_property.name)
        expect(response.body).to include(decorated_property.full_address)
        expect(response.body).to include(decorated_property.formatted_area_square_meters)
        expect(response.body).to include(decorated_property.formatted_rent)
        expect(response.body).to include(decorated_property.formatted_property_type)
      end
    end

    context "with :property_type parameter" do
      before do
        properties[0].update!(property_type: :house)
        properties[1].update!(property_type: :house)
        properties[2].update!(property_type: :mansion)
      end

      let(:property_type) { "house" }

      it "renders the index template with filtered properties" do
        get properties_index_path(property_type:)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Properties (2)")
        expect(response.body).to include("All the imported properties.")

        properties.first(2).select { |property| property.property_type == property_type }.map(&:decorate).each do |property|
          expect(response.body).to include(property.external_id)
          expect(response.body).to include(property.name)
          expect(response.body).to include(property.full_address)
          expect(response.body).to include(property.formatted_area_square_meters)
          expect(response.body).to include(property.formatted_rent)
          expect(response.body).to include(property.formatted_property_type)
        end

        properties.last.decorate.tap do |property|
          expect(response.body).not_to include(property.external_id)
        end
      end
    end
  end
end
