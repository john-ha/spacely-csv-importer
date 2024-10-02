require "rails_helper"

RSpec.describe Imports::ParseCsvService, type: :service do
  describe "#call" do
    let(:import_history) { create(:import_history, import_status:, imported_file:) }

    context "when the file contains only valid data" do
      let(:import_status) { :started }
      let(:imported_file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

      it "creates Properties" do
        expect { described_class.call(import_history: import_history) }.to change(Property, :count).by(10)

        properties = Property.all

        expected_properties_attributes = CSV.read(imported_file.path,
          headers: true,
          header_converters: lambda { |header| Imports::ParseCsvService::HEADERS[header] }).map do |row|
            {
              "external_id" => row[:external_id],
              "name" => row[:name],
              "address" => row[:address],
              "room_number" => row[:room_number],
              "rent" => row[:rent].to_i,
              "area_square_meters" => row[:area_square_meters].to_f,
              "property_type" => Imports::ParseCsvService::PROPERTY_TYPES_MAPPING[row[:property_type]].to_s
            }
          end

        imported_properties_attributes = properties.map do |property|
          property.attributes.slice(*Imports::ParseCsvService::HEADERS.values.map(&:to_s))
        end

        expect(imported_properties_attributes).to eq(expected_properties_attributes)
      end

      it "creates ImportHistoriesProperty" do
        expect { described_class.call(import_history:) }.to change(ImportHistoriesProperty, :count).by(10)

        properties = Property.all.pluck(:id)

        import_history_properties = ImportHistoriesProperty.all.pluck(:import_history_id, :property_id)

        expect(import_history_properties).to match_array(
          properties.map { |property_id| [import_history.id, property_id] }
        )
      end

      it "updates ImportHistory status to :completed" do
        described_class.call(import_history:)

        import_history.reload

        expect(import_history.import_status).to eq("completed")
        expect(import_history.imported_properties_count).to eq(10)
      end
    end

    context "when the file contains invalid data" do
      let(:import_status) { :started }
      let(:imported_file) { fixture_file_upload("invalid_rows_10_rows.csv", "text/csv") }

      it "updates ImportHistory status to :failed" do
        expect { described_class.call(import_history:) }
          .to change(Property, :count).by(0)
          .and change(ImportHistoriesProperty, :count).by(0)

        import_history.reload

        expect(import_history.import_status).to eq("failed")
        expect(import_history.import_failure_type).to eq("invalid_rows")
        expect(import_history.imported_file_with_errors).to be_attached # TODO: check the content of the file
      end
    end

    context "when the file contains invalid headers" do
      let(:import_status) { :started }
      let(:imported_file) { fixture_file_upload("invalid_headers.csv", "text/csv") }

      it "updates ImportHistory status to :failed" do
        expect { described_class.call(import_history:) }
          .to change(Property, :count).by(0)
          .and change(ImportHistoriesProperty, :count).by(0)

        import_history.reload

        expect(import_history.import_status).to eq("failed")
        expect(import_history.import_failure_type).to eq("invalid_headers")
      end
    end

    context "when an unexpected error occurs" do
      let(:import_status) { :started }
      let(:imported_file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

      before do
        allow(CSV).to receive(:open).and_raise(StandardError)
      end

      it "updates ImportHistory status to :failed" do
        expect { described_class.call(import_history:) }.to raise_error(StandardError)
          .and change(Property, :count).by(0)
          .and change(ImportHistoriesProperty, :count).by(0)

        import_history.reload

        expect(import_history.import_status).to eq("failed")
        expect(import_history.import_failure_type).to eq("unknown_error")
      end
    end
  end
end
