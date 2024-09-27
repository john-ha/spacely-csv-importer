Rails.application.routes.draw do
  # redirect to imports#index
  root to: redirect("/imports/index")

  get "imports/index"
  get "imports/new"
  get "imports/:import_history_id", to: "imports#show", as: "imports_show"
  get "imports/:import_history_id/error_file", to: "imports#download_error_file", as: "imports_download_error_file"
  get "imports/:import_history_id/original_file", to: "imports#download_original_file", as: "imports_download_original_file"

  post "imports/upload"
end
