class ImportsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  DEFAULT_IMPORTS_PER_PAGE = 10
  DEFAULT_IMPORTS_PROPERTIES_PER_PAGE = 10

  # GET /imports
  # GET /imports.json
  def index
    param!(:page, Integer, default: 1)
    param!(:per, Integer, default: DEFAULT_IMPORTS_PER_PAGE)

    page = params[:page]
    per = params[:per]

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
    param!(:import_history_id, String, required: true)
    param!(:page, Integer, default: 1)
    param!(:per, Integer, default: DEFAULT_IMPORTS_PROPERTIES_PER_PAGE)

    page = params[:page]
    per = params[:per]

    @import_history = ImportHistory.find(params[:import_history_id]).decorate
    @properties = @import_history.properties.order(external_id: :asc).page(page).per(per).decorate

    respond_to do |format|
      format.html
      format.json { render json: {total_count: @properties.total_count, total_pages: @properties.total_pages, properties: @properties} }
    end
  end

  # GET /imports/import_history.json
  def import_history
    param!(:import_history_id, String, required: true)

    @import_history = ImportHistory.find(params[:import_history_id]).decorate

    render json: @import_history
  end

  # POST /imports/upload
  # POST /imports/upload.json
  def upload
    param!(:file, ActionDispatch::Http::UploadedFile, required: true)

    @import_history = Imports::UploadService.call(file: params[:file]).decorate

    respond_to do |format|
      format.html { redirect_to imports_index_path }
      format.json { render json: @import_history.as_json(only: :id), status: :ok }
    end
  end

  # GET /imports/:import_history_id/download_original_file
  def download_original_file
    param!(:import_history_id, String, required: true)

    import_history = ImportHistory.find(params[:import_history_id]).decorate

    send_data(import_history.imported_file.download, filename: "import_#{import_history.id}.csv", type: "text/csv")
  end

  # GET /imports/:import_history_id/download_error_file
  def download_error_file
    param!(:import_history_id, String, required: true)

    import_history = ImportHistory.find(params[:import_history_id]).decorate

    send_data(import_history.imported_file_with_errors.download, filename: "import_errors_#{import_history.id}.csv", type: "text/csv")
  end
end
