Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'dashboard', to: 'dashboard#index'

  get 'admin', to: 'admins#dashboard', as: 'admin' 
  
  get 'admin/importar', to: 'admins#import_form', as: 'admin_importar_form'
  post 'admin/importar', to: 'admins#importar'

  get 'admin/send_forms', to: 'admins#send_forms', as: 'admin_send_forms'

  get 'admin/templates', to: 'admins#edit_templates', as: 'admin_edit_templates'
  get 'admin/templates/new', to: 'admins#new_template', as: 'admin_new_template'
  post 'admin/templates', to: 'admins#create_template', as: 'admin_templates' 
  delete 'admin/templates/:id', to: 'admins#destroy_template', as: 'admin_template_delete'

  scope '/admin' do
    resources :resultados, only: [:index] do
      member do
        get :baixar 
      end
    end
  end

  root to: 'dashboard#index'

  resources :formularios, only: [:show] do
    member do
      post :responder
    end
  end
end