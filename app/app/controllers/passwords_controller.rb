# Gerencia a alteração de senha para usuários já autenticados (troca de senha).
# Diferente do PasswordResets, este controller exige que o usuário esteja logado.
class PasswordsController < ApplicationController
  before_action :require_login

  # Exibe o formulário para o usuário alterar sua própria senha.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'edit'.
  # Efeitos Colaterais: Nenhum.
  def edit
  end

  # Processa a atualização da senha do usuário logado.
  #
  # Args:
  #   - params[:usuario] (Hash): Contém :password e :password_confirmation.
  #   - current_user (Usuario): O usuário autenticado na sessão.
  # Retorno:
  #   - Redireciona para dashboard_path (sucesso).
  #   - Renderiza a view 'edit' (erro de validação).
  # Efeitos Colaterais:
  #   - Atualiza o campo password_digest no banco de dados.
  #   - Define mensagens flash (notice).
  def update
    if current_user.update(password_params)
      redirect_to dashboard_path, notice: "Senha alterada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Filtra os parâmetros permitidos para a alteração de senha (Strong Parameters).
  #
  # Args: params (ActionController::Parameters)
  # Retorno: Hash contendo apenas :password e :password_confirmation.
  # Efeitos Colaterais: Nenhum.
  def password_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end
end