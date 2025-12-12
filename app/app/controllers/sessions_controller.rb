# Gerencia o ciclo de vida da autenticação do usuário (Login e Logout).
# Responsável por criar e destruir a sessão do usuário no navegador.
class SessionsController < ApplicationController
  def new; end

  def create
    user = Usuario.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logado com sucesso!'
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Deslogado.'
  end
end