# frozen_string_literal: true

# Handle exceptions in the application and return appropriate responses.
# NOTE: this module is included in the ApplicationController.
module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from StandardError do |e|
      Rails.logger.error "[StandardError] #{e.message}"
      Rails.logger.error "[StandardError] #{e.backtrace.join("\n")}"

      respond_to do |format|
        format.html do
          flash[:error] = "An error occurred."
          redirect_to root_path
        end

        format.json do
          render json: {
            errors: []
          }, status: :internal_server_error
        end
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rails.logger.warn("[ActiveRecord::RecordNotFound] #{e.message}.")
      Rails.logger.warn("[ActiveRecord::RecordNotFound] #{e.backtrace.join("\n")}.")

      respond_to do |format|
        format.html do
          flash[:error] = "Record not found."
          redirect_to root_path
        end

        format.json do
          render json: {
            errors: ["Record not found."]
          }, status: :not_found
        end
      end
    end

    rescue_from RailsParam::InvalidParameterError do |e|
      Rails.logger.warn("[RailsParam::InvalidParameterError] #{e.message}.")
      Rails.logger.warn("[RailsParam::InvalidParameterError] #{e.backtrace.join("\n")}.")

      respond_to do |format|
        format.html do
          flash[:error] = "Invalid parameter."
          redirect_to root_path
        end

        format.json do
          render json: {
            errors: []
          }, status: :bad_request
        end
      end
    end
  end
end
