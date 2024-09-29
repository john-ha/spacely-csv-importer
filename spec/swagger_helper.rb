# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join("swagger").to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1"
      },
      paths: {},
      components: {
        schemas: {
          import_history: {
            type: "object",
            properties: {
              id: {type: :integer, required: true},
              import_status: {
                type: :string,
                enum: ["Started", "Completed", "Failed"],
                required: true
              },
              imported_properties_count: {type: :integer, required: true},
              imported_at: {type: :string, format: "date-time", required: true},
              import_failure_type: {
                type: :string,
                enum: ["Unknown error", "Invalid headers", "Invalid rows"]
              },
              created_at: {type: :string, format: "date-time", required: true},
              updated_at: {type: :string, format: "date-time", required: true}
            }
          },
          property: {
            type: "object",
            properties: {
              id: {type: :integer},
              external_id: {type: :string},
              name: {type: :string},
              address: {type: :string},
              room_number: {type: :string},
              rent: {type: :string},
              area_square_meters: {type: :string},
              property_type: {type: :string, enum: ["Appartment", "House", "Mansion"]},
              created_at: {type: :string, format: "date-time"},
              updated_at: {type: :string, format: "date-time"}
            }
          }
        }
      },
      servers: [
        {
          url: "{protocol}://{defaultHost}",
          variables: {
            protocol: {
              default: "http",
              enum: ["https", "http"]
            },
            defaultHost: {
              default: "www.example.com"
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
