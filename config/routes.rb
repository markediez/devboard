Rails.application.routes.draw do
  resources :exception_reports
  resources :sprints
  resources :milestones
  resources :meeting_notes

  get '/overview' => 'site#overview'
  get '/access_denied' => 'site#access_denied'
  get '/credentials' => 'site#credentials'
  post '/credentials' => 'site#credentials'
  get '/logout' => 'site#logout'

  post '/tasks/unassign' => 'tasks#unassign'

  post 'exception_reports/new_task' => 'exception_reports#new_task'

  resources :tasks
  resources :developers
  resources :developer_accounts
  resources :projects
  resources :sprints

  root 'site#overview'
end
