# Gerencia o fluxo de redefinição de senha (esqueci minha senha).
# Permite solicitar um link por email e redefinir a senha usando um token seguro.
class PasswordResetsController < ApplicationController
  before_action :resolve_user_from_token, only: %i[edit update]

  # Exibe o formulário para o usuário informar o e-mail e solicitar o link.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'new'.
  # Efeitos Colaterais: Nenhum.
  def new; end

  # Processa a solicitação de redefinição. Busca o usuário e dispara o e-mail.
  #
  # Args:
  #   - params[:email] (String): O e-mail cadastrado do usuário.
  # Retorno:
  #   - Redireciona para login_path (se o usuário existir e o email for enviado).
  #   - Renderiza a view 'new' (se o e-mail não for encontrado).
  # Efeitos Colaterais:
  #   - Gera um token de redefinição no banco (via model).
  #   - Envia um e-mail com o link de recuperação (UserMailer).
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

  # Exibe o formulário para digitação da nova senha (acessado via link do email).
  #
  # Args:
  #   - params[:email] (String): E-mail do usuário (validado no before_action).
  #   - params[:id] (String): Token de redefinição (validado no before_action).
  # Retorno: Renderiza a view 'edit'.
  # Efeitos Colaterais: Nenhum (validações ocorrem no filtro).
  def edit; end

  # Atualiza a senha do usuário no banco de dados.
  #
  # Args:
  #   - user_params (Hash): Contém :password e :password_confirmation.
  # Retorno:
  #   - Redireciona para login_path com sucesso.
  #   - Renderiza a view 'edit' em caso de erro de validação (ex: senhas não batem).
  # Efeitos Colaterais:
  #   - Atualiza a senha (criptografada) no banco de dados.
  #   - Limpa o token de redefinição (reset_digest) após o uso.
  def update
    if @user.update(user_params)
      @user.clear_reset_digest
      redirect_to login_path, notice: "Senha redefinida com sucesso! Faça login."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Filtra os parâmetros permitidos para atualização de senha.
  #
  # Args: params[:usuario] (ActionController::Parameters)
  # Retorno: Hash com :password e :password_confirmation.
  # Efeitos Colaterais: Nenhum.
  def user_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end

  # Filtro (before_action) que valida se o link de redefinição é legítimo.
  # Verifica se o usuário existe e se o token é válido e não expirou.
  #
  # Args:
  #   - params[:email]
  #   - params[:id] (Token)
  # Retorno:
  #   - nil (se válido, define a variável de instância @user).
  #   - Redireciona para new_password_reset_path (se inválido).
  # Efeitos Colaterais:
  #   - Define a variável @user para uso nas actions edit/update.
  #   - Interrompe a requisição se o token for inválido.
  def resolve_user_from_token
    @user = Usuario.find_by(email: params[:email])

    @token = params[:id] 

    return if @user&.valid_reset_token?(@token)

    redirect_to new_password_reset_path, alert: "Link inválido ou expirado."
  end
end