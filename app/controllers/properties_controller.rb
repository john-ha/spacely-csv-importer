class PropertiesController < ApplicationController
  DEFAULT_PROPERTIES_PER_PAGE = 10

  def index
    param!(:page, Integer, default: 1)
    param!(:per, Integer, default: DEFAULT_PROPERTIES_PER_PAGE)

    page = params[:page]
    per = params[:per]

    @properties = Property.all.order(:external_id).page(page).per(per).decorate

    respond_to do |format|
      format.html
      format.json { render json: @properties }
    end
  end
end
