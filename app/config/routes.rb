Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'dashboard', to: 'dashboard#index'

  get 'admin', to: 'admins#dashboard', as: 'admin' 
  get 'admin/importar', to: 'admins#import_form', as: 'admin_importar_form'
  post 'admin/importar', to: 'admins#importar'

  root to: 'dashboard#index'
end
