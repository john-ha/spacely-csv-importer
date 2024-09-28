require "rails_helper"

RSpec.describe Imports, type: :request do
  describe "GET /imports" do
    let!(:import_histories) { create_list(:import_history, 3) }

    context "when :format is :html" do
      it "renders the index template" do
        get imports_index_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Import History")
        expect(response.body).to include("All the imports that have been done.")

        import_histories.map(&:decorate).each do |import_history|
          expect(response.body).to include(import_history.id.to_s)
          expect(response.body).to include(import_history.imported_properties_count.to_s)
          expect(response.body).to include(import_history.imported_at.to_s)
          expect(response.body).to include(import_history.import_status)
          expect(response.body).to include(imports_show_path(import_history))
        end

        expect(response.body).to include(imports_new_path)
      end
    end

    context "when :format is :json" do
      it "returns a list of import histories" do
        get imports_index_path, as: :json

        # Sort the import histories by :imported_at in descending order
        decorated_import_histories = import_histories
          .sort do |a, b|
            b.imported_at <=> a.imported_at
          end
          .map(&:decorate)

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(decorated_import_histories.to_json)
      end
    end
  end

  describe "GET /imports/new" do
    it "renders the new template" do
      get imports_new_path

      expect(response).to have_http_status(:ok)

      expect(response.body).to include("Import properties")
      expect(response.body).to include("Upload your CSV file and import properties.")

      expect(response.body).to include(imports_upload_path)
    end
  end

  describe "GET /imports/:import_history_id" do
    let(:import_history) { create(:import_history, :with_properties) }

    context "when :format is :html" do
      it "renders the show template" do
        get imports_show_path(import_history)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Properties of import ##{import_history.id} (#{import_history.imported_at})")
        expect(response.body).to include("All the properties that have been imported.")

        import_history.properties.map(&:decorate).each do |property|
          expect(response.body).to include(property.external_id.to_s)
          expect(response.body).to include(property.name)
          expect(response.body).to include(property.full_address)
          expect(response.body).to include(property.area_square_meters.to_s)
          expect(response.body).to include(property.rent.to_s)
          expect(response.body).to include(property.property_type)
        end
      end
    end

    context "when :format is :json" do
      it "returns the import history and its properties" do
        get imports_show_path(import_history), as: :json

        decorated_import_history = import_history.decorate
        decorated_properties = import_history.properties.sort_by(&:external_id).map(&:decorate)

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({import_history: decorated_import_history, properties: decorated_properties}.to_json)
      end
    end
  end

  describe "POST /imports/upload" do
    let(:file) { fixture_file_upload("valid_data.csv", "text/csv") }

    it "redirects to the imports index page" do
      post imports_upload_path, params: {file:}

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(imports_index_path)
    end
  end

  describe "GET /imports/:import_history_id/download_original_file" do
    let(:import_history) { create(:import_history, imported_file: fixture_file_upload("valid_data.csv", "text/csv")) }

    it "downloads the original file" do
      get imports_download_original_file_path(import_history)

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(import_history.imported_file.download)
    end
  end

  describe "GET /imports/:import_history_id/download_error_file" do
    let(:import_history) { create(:import_history, imported_file_with_errors: fixture_file_upload("imported_file_with_errors.csv", "text/csv")) }

    it "downloads the error file" do
      get imports_download_error_file_path(import_history)

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(import_history.imported_file_with_errors.download)
    end
  end
end
