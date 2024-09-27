Rails.application.routes.draw do
  get "imports/index"
  get "imports/new"
  get "imports/show"

  post "imports/upload"
end
