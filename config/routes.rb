Rails.application.routes.draw do
  resources :meeting_notes

  get '/overview' => 'site#overview'
  get '/access_denied' => 'site#access_denied'

  resources :tasks
  resources :developers
  resources :projects

  root 'site#overview'
end
