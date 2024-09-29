class ImportsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  # GET /imports
  # GET /imports.json
  def index
    page = params[:page] || 1
    per = params[:per] || 10

    @import_histories = ImportHistory.all.order(imported_at: :desc).page(page).per(per).decorate

    respond_to do |format|
      format.html
      format.json { render json: @import_histories }
    end
  end

  # GET /imports/new
  def new
  end

  # GET /imports/:import_history_id/properties
  # GET /imports/:import_history_id/properties.json
  def import_history_properties
    page = params[:page] || 1
    per = params[:per] || 10

    @import_history = ImportHistory.find(params[:import_history_id]).decorate
    @properties = @import_history.properties.order(external_id: :asc).page(page).per(per).decorate

    respond_to do |format|
      format.html
      format.json { render json: {total_count: @properties.total_count, total_pages: @properties.total_pages, properties: @properties} }
    end
  end

  # GET /imports/import_history.json
  def import_history
    @import_history = ImportHistory.find(params[:import_history_id]).decorate

    render json: @import_history
  end

  # POST /imports/upload
  # POST /imports/upload.json
  def upload
    import_history_id = Imports::UploadService.call(file: params[:file])

    respond_to do |format|
      format.html { redirect_to imports_index_path }
      format.json { render json: {import_history_id:}, status: :ok }
    end
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
