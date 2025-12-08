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
  
  # CORREÇÃO: Ativamos a rota POST. O helper gerado por essa linha é admin_templates_path,
  # que o form_with espera para a criação (action: create).
  post 'admin/templates', to: 'admins#create_template', as: 'admin_templates' 

  root to: 'dashboard#index'
end