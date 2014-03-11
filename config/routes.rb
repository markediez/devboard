Rails.application.routes.draw do
  resources :meeting_notes

  get '/overview' => 'site#overview'
  get '/access_denied' => 'site#access_denied'
  get '/credentials' => 'site#credentials'
  post '/credentials' => 'site#credentials'

  resources :tasks
  resources :developers
  resources :projects

  root 'site#overview'
end
