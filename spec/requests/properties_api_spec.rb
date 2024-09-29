require "swagger_helper"

RSpec.describe "properties", type: :request do
  path "/properties" do
    get("Lists the properties.") do
      tags "Properties"
      produces "application/json"
      description "Lists the properties."

      let!(:properties) { create_list(:property, 3) }

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
