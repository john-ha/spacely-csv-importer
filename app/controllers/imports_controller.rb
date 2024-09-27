class ImportsController < ApplicationController
  def index
    @import_histories = ImportHistory.all.order(imported_at: :desc).decorate

    respond_to do |format|
      format.html
      format.json { render json: @import_histories }
    end
  end

  def new
  end

  def show
    @import_history = ImportHistory.find(params[:import_history_id]).decorate
    @properties = @import_history.properties.decorate
  end

  def upload
  end
end
