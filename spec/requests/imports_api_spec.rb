require "swagger_helper"

RSpec.describe "imports", type: :request do
  path "/imports" do
    get("Lists the import histories.") do
      tags "Imports"
      produces "application/json"
      description "Lists the import histories."

      let(:import_histories) { create_list(:import_history, 3) }

      response(200, "List of the import histories returned successfully.") do
        schema type: :array, items: {"$ref" => "#/components/schemas/import_history"}

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

        run_test!
      end
    end
  end

  path "/imports/{import_history_id}/properties" do
    parameter name: "import_history_id", in: :path, type: :string, description: "ID of the import history", required: true

    let(:import_history_id) { create(:import_history, :with_properties).id }

    get("Lists the properties of an import history.") do
      tags "Imports"
      produces "application/json"
      description "Lists the imported properties of an import history."

      response(200, "List of the properties returned successfully.") do
        schema type: :object, properties: {
          total_count: {type: :integer, description: "Total number of imported properties", required: true},
          total_pages: {type: :integer, description: "Total number of pages", required: true},
          properties: {type: :array, items: {"$ref" => "#/components/schemas/property"}, description: "List of imported properties", required: true}
        }

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

        run_test!
      end
    end
  end

  # Reference: https://github.com/rswag/rswag/issues/348#issuecomment-1386130773
  path "/imports/upload" do
    post("Upload a CSV file to import properties.") do
      tags "Imports"
      consumes "multipart/form-data"
      produces "application/json"
      description "Uploads a CSV file to import properties."

      parameter name: "", in: :formData, schema: {
        type: :object,
        properties: {
          file: {type: :string, format: :binary, description: "CSV file to upload", required: true}
        },
        required: ["file"]
      }

      let(:"") { {file: fixture_file_upload("valid_data.csv", "text/csv")} }

      response(200, "Upload performed successfully.") do
        schema type: :object, properties: {}

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

        run_test!
      end
    end
  end
end
