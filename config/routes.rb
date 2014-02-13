Rails.application.routes.draw do
  get "site/overview"

  resources :tasks
  resources :developers
  resources :projects

  root 'site#overview'
end
