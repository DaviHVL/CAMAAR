Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'cadastro', to: 'users#new', as: 'cadastro'
  post 'cadastro', to: 'users#create'

  get 'dashboard', to: 'dashboard#index'
  root to: 'dashboard#index'

  get 'admin', to: 'admins#dashboard', as: 'admin'

  get 'admin/importar', to: 'admins#import_form', as: 'admin_importar_form'
  post 'admin/importar', to: 'admins#importar'

  get 'admin/send_forms', to: 'admins#send_forms', as: 'admin_send_forms'
  post 'admin/send_forms', to: 'admins#process_send_forms', as: 'admin_process_send_forms'

  resources :templates

  scope '/admin' do
    resources :resultados, only: [:index] do
      member do
        get :baixar
      end
    end
  end

  resource :password, only: [:edit, :update]

  resources :formularios, only: [:show] do
    member do
      post :responder
    end
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
end