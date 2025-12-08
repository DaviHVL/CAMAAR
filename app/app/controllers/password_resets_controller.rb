class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = Usuario.find_by(email: params[:email])
    
    if user
      token = user.generate_password_reset_token!
      UserMailer.password_reset(user, token).deliver_now
      redirect_to login_path, notice: "Email enviado com instruções!"
    else
      flash.now[:alert] = "Email não encontrado"
      render :new
    end
  end

  def edit
    @user = Usuario.find_by(email: params[:email])
    @token = params[:id]

    unless link_valido?(@user, @token)
      redirect_to new_password_reset_path, alert: "Link inválido ou expirado."
    end
  end

  def update
    @user = Usuario.find_by(email: params[:email])
    @token = params[:id]

    unless link_valido?(@user, @token)
      redirect_to new_password_reset_path, alert: "Link inválido."
      return
    end

    if @user.update(user_params)
      @user.update_columns(reset_digest: nil, reset_sent_at: nil)
      redirect_to login_path, notice: "Senha redefinida com sucesso! Faça login."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end

  def link_valido?(user, token)
    user && 
    user.reset_digest.present? &&
    !user.password_reset_expired? && 
    BCrypt::Password.new(user.reset_digest).is_password?(token)
  end
end