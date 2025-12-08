Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'dashboard', to: 'dashboard#index'

  # Rotas de Administração
  get 'admin', to: 'admins#dashboard', as: 'admin' 
  
  # Rotas de Importação
  get 'admin/importar', to: 'admins#import_form', as: 'admin_importar_form'
  post 'admin/importar', to: 'admins#importar'

  # Rotas de Envio de Formulários
  get 'admin/send_forms', to: 'admins#send_forms', as: 'admin_send_forms'

  # Rotas de Gerenciamento de Templates
  get 'admin/templates', to: 'admins#edit_templates', as: 'admin_edit_templates'
  get 'admin/templates/new', to: 'admins#new_template', as: 'admin_new_template'
  

  post 'admin/templates', to: 'admins#create_template', as: 'admin_templates' 

  delete 'admin/templates/:id', to: 'admins#destroy_template', as: 'admin_template_delete'

  # 1. GET para exibir o formulário de edição
  get 'admin/templates/:id/edit', to: 'admins#edit_template', as: 'admin_edit_template_form'
  # 2. PATCH para submeter as atualizações
  patch 'admin/templates/:id', to: 'admins#update_template', as: 'admin_template_update'

  root to: 'dashboard#index'

  resources :formularios, only: [:show] do
    member do
      post :responder
    end
  end
end