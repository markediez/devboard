Rails.application.routes.draw do
  resources :exception_reports
  resources :sprints
  resources :milestones
  resources :meeting_notes
  resources :tasks
  resources :developers
  resources :developer_accounts
  resources :projects
  resources :sprints
  resources :assignments

  get '/access_denied' => 'site#access_denied'
  get '/credentials' => 'site#credentials'
  post '/credentials' => 'site#credentials'
  get '/logout' => 'site#logout'

  post '/tasks/unassign' => 'tasks#unassign'
  post '/tasks/sort' => 'tasks#sort'

  post 'exception_reports/new_task' => 'exception_reports#new_task'

  root 'assignments#index'
end
