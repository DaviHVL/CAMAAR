class PasswordsController < ApplicationController
  before_action :require_login

  def edit
  end

  def update
    if current_user.update(password_params)
      redirect_to dashboard_path, notice: "Senha alterada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end
end