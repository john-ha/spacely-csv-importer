# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExceptionHandler" do
  describe "rescue_from StandardError" do
    before do
      allow(ImportHistory).to receive(:all).and_raise(StandardError)
    end

    context "when :format is :html" do
      it "redirects to root_path" do
        get imports_index_path

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("An error occurred.")
      end
    end

    context "when :format is :json" do
      it "returns a :internal_server_error" do
        get imports_index_path, as: :json

        expect(response).to have_http_status(:internal_server_error)
        expect(response.body).to eq({
          errors: []
        }.to_json)
      end
    end
  end

  describe "rescue_from ActiveRecord::RecordNotFound" do
    context "when :format is :html" do
      it "redirects to root_path" do
        get imports_import_history_properties_path(import_history_id: 0)

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Record not found.")
      end
    end

    context "when :format is :json" do
      it "returns a :not_found" do
        get imports_import_history_properties_path(import_history_id: 0), as: :json

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({
          errors: ["Record not found."]
        }.to_json)
      end
    end
  end

  describe "rescue_from RailsParam::InvalidParameterError" do
    context "when :format is :html" do
      it "redirects to root_path" do
        get imports_import_history_properties_path(import_history_id: 1, page: "invalid")

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Invalid parameter.")
      end
    end

    context "when :format is :json" do
      it "returns a :bad_request" do
        get imports_import_history_properties_path(import_history_id: 1, page: "invalid"), as: :json

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          errors: []
        }.to_json)
      end
    end
  end
end
