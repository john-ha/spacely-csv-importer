require "swagger_helper"

RSpec.describe "properties", type: :request do
  path "/properties" do
    get("Lists the properties.") do
      tags "Properties"
      produces "application/json"
      description "Lists the properties."

      parameter name: :page, in: :query, type: :integer, default: 1
      parameter name: :per, in: :query, type: :integer, default: 10
      parameter name: :search, in: :query, type: :string
      parameter name: :property_type, in: :query, type: :string, enum: Property.property_types.keys

      let!(:properties) { create_list(:property, 3) }

      let(:page) { 1 }
      let(:per) { 10 }
      let(:search) { nil }
      let(:property_type) { nil }

      response(200, "List of the properties returned successfully.") do
        schema type: :array, items: {"$ref" => "#/components/schemas/property"}

        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json" => {
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test! do |response|
          # Sort the properties by :external_id in asc order
          decorated_properties = properties
            .sort_by(&:external_id)
            .map(&:decorate)

          expect(response.body).to eq(decorated_properties.to_json)
        end
      end
    end
  end
end
