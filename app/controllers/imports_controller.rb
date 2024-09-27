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
    Imports::UploadService.call(file: params[:file])

    redirect_to imports_index_path
  end

  def download_error_file
    import_history = ImportHistory.find(params[:import_history_id])

    send_data import_history.imported_file_with_errors.download, filename: "import_errors_#{import_history.id}.csv"
  end
end
