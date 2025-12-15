# Gerencia o fluxo de redefinição de senha (esqueci minha senha).
# Permite solicitar um link por email e redefinir a senha usando um token.
class PasswordResetsController < ApplicationController
  before_action :resolve_user_from_token, only: %i[edit update]

  def new; end

  def create
    user = Usuario.find_by(email: params[:email])
    
    if user
      user.send_password_reset_email 
      redirect_to login_path, notice: "Email enviado com instruções!"
    else
      flash.now[:alert] = "Email não encontrado"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      @user.clear_reset_digest
      redirect_to login_path, notice: "Senha redefinida com sucesso! Faça login."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end

  def resolve_user_from_token
    @user = Usuario.find_by(email: params[:email])

    @token = params[:id] 

    return if @user&.valid_reset_token?(@token)

    redirect_to new_password_reset_path, alert: "Link inválido ou expirado."
  end
end