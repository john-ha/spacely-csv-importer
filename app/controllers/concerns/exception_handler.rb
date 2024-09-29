# frozen_string_literal: true

# Handle exceptions in the application and return appropriate responses.
# NOTE: this module is included in the ApplicationController.
module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from StandardError do |e|
      respond_to do |format|
        format.html do
          flash[:error] = e.message
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
      respond_to do |format|
        format.html do
          flash[:error] = e.message
          redirect_to root_path
        end

        format.json do
          render json: {
            errors: [e.message]
          }, status: :not_found
        end
      end
    end
  end
end
