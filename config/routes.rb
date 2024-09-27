Rails.application.routes.draw do
  # redirect to imports#index
  root to: redirect("/imports/index")

  get "imports/index"
  get "imports/new"
  get "imports/show/:import_history_id", to: "imports#show", as: "imports_show"

  post "imports/upload"
end
