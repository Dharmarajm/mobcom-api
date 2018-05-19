Rails.application.routes.draw do

  root to: "sessions#new"

  get 'logout' => 'sessions#destroy'
  get 'detailed_report' => 'projects#detailed_report'
  get 'employee_report' => 'employees#employee_report'
  post 'employee_report' => 'employees#employee_report'
  get 'project_report' => 'projects#project_report'
  post 'project_report' => 'projects#project_report'  
  get 'users/old_password_check'
  get 'users/change_password'
  post 'users/change_password_update'
  get 'projects/project_active_status'
  get 'users/new_password'
  post 'users/set_new_password'
  get 'clients/sample_csv'
  get 'sessions/new'
  post 'employees/import_employee'
  get 'clients/dashboard'
  
  resources :sessions
  resources :users  
  resources :projects
  resources :employees
  resources :clients

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'is_absent' => 'time_sheets#is_absent'
      get 'time_sheets/date'
      get 'employees/assigned_project'
      get 'users/forgot_password'
      get 'projects/approval_status'
      get 'time_sheets/time_approval_status'
      post 'employees/image_upload'
      get 'logs/call_index'
      get 'logs/call_show'
      post 'logs/call_create'
      put 'logs/call_update'
      get 'logs/message_index'
      get 'logs/message_show'
      post 'logs/message_create'
      put 'logs/message_update'
      get 'time_sheets/project_working_hours'
      get 'clients/client_contacts'
      get 'clients/client_projects'
      get 'employees/unassigned_project'
      get 'time_sheets/cost_estimate'
      get 'contacts/client_contacts'
      get 'projects/project_employee'
      get 'time_sheets/employee_time_sheet'
      get 'employees/project_assign'
      get 'users/user_registration'
      get 'users/login_validation'
      get 'employees/employee_details'	
      resources :contacts
      resources :users	
      resources :employees
      resources :clients
      resources :projects
      resources :roles
      resources :time_sheets
    end
  end
end