Rails.application.routes.draw do
  resources :sprints
  resources :milestones
  resources :meeting_notes
  resources :tasks
  resources :developers
  resources :developer_accounts
  resources :projects
  resources :sprints
  resources :exception_filters

  resources :exception_reports

  resources :assignments, :except => [:show]
  get '/assignments/:date' => 'assignments#index'

  get '/access_denied' => 'site#access_denied'
  get '/credentials' => 'site#credentials'
  post '/credentials' => 'site#credentials'
  get '/logout' => 'site#logout'


  root 'site#root'

end
