Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  root to: redirect("/imports")

  get "imports", to: "imports#index", as: "imports_index"
  get "imports/new"
  get "imports/:import_history_id", to: "imports#import_history", as: "imports_import_history"
  get "imports/:import_history_id/properties", to: "imports#import_history_properties", as: "imports_import_history_properties"
  get "imports/:import_history_id/error_file", to: "imports#download_error_file", as: "imports_download_error_file"
  get "imports/:import_history_id/original_file", to: "imports#download_original_file", as: "imports_download_original_file"
  post "imports/upload"

  get "properties", to: "properties#index", as: "properties_index"
end
