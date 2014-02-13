Rails.application.routes.draw do
  get '/overview' => 'site#overview'
  get '/access_denied' => 'site#access_denied'

  resources :tasks
  resources :developers
  resources :projects

  root 'site#overview'
end
