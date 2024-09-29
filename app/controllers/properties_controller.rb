class PropertiesController < ApplicationController
  def index
    page = params[:page] || 1
    per = params[:per] || 10

    @properties = Property.all.order(:external_id).page(page).per(per).decorate

    respond_to do |format|
      format.html
      format.json { render json: @properties }
    end
  end
end
