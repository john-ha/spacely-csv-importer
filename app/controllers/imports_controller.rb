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
  end

  def upload
  end
end
