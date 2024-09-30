class PropertiesController < ApplicationController
  DEFAULT_PROPERTIES_PER_PAGE = 10

  def index
    param!(:page, Integer, default: 1)
    param!(:per, Integer, default: DEFAULT_PROPERTIES_PER_PAGE)
    param!(:search, String, default: nil)
    param!(:property_type,
      String,
      default: nil,
      in: Property.property_types.keys, transform: ->(value) { value.presence }) # Convert empty string to nil

    @properties, @query = Properties::FilteredPropertiesQuery.call(
      Property.all,
      search: params[:search],
      property_type: params[:property_type],
      page: params[:page],
      per: params[:per]
    )

    @properties = @properties.decorate

    respond_to do |format|
      format.html
      format.json { render json: @properties }
    end
  end
end
