class ImportsController < ApplicationController
  # GET /imports
  # GET /imports.json
  def index
    @import_histories = ImportHistory.all.order(imported_at: :desc).decorate

    respond_to do |format|
      format.html
      format.json { render json: @import_histories }
    end
  end

  # GET /imports/new
  def new
  end

  # GET /imports/:import_history_id
  # GET /imports/:import_history_id.json
  def show
    @import_history = ImportHistory.find(params[:import_history_id]).decorate
    @properties = @import_history.properties.order(external_id: :asc).decorate

    respond_to do |format|
      format.html
      format.json { render json: {import_history: @import_history, properties: @properties} }
    end
  end

  # POST /imports/upload
  def upload
    Imports::UploadService.call(file: params[:file])

    redirect_to imports_index_path
  end

  # GET /imports/:import_history_id/download_original_file
  def download_original_file
    import_history = ImportHistory.find(params[:import_history_id])

    send_data(import_history.imported_file.download, filename: "import_#{import_history.id}.csv", type: "text/csv")
  end

  # GET /imports/:import_history_id/download_error_file
  def download_error_file
    import_history = ImportHistory.find(params[:import_history_id])

    send_data(import_history.imported_file_with_errors.download, filename: "import_errors_#{import_history.id}.csv", type: "text/csv")
  end
end
