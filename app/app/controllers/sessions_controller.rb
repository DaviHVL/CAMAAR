# Gerencia o ciclo de vida da autenticação do usuário (Login e Logout).
# Responsável por criar e destruir a sessão do usuário no navegador.
class SessionsController < ApplicationController
  
  # Exibe o formulário de login para o usuário.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'new'.
  # Efeitos Colaterais: Nenhum.
  def new; end

  # Processa as credenciais de login enviadas pelo formulário.
  # Verifica se o usuário existe e se a senha confere.
  #
  # Args:
  #   - params[:email] (String): O e-mail do usuário.
  #   - params[:password] (String): A senha em texto plano.
  # Retorno:
  #   - Redireciona para root_path (se as credenciais forem válidas).
  #   - Renderiza a view 'new' com status unprocessable_entity (se inválidas).
  # Efeitos Colaterais:
  #   - Realiza consulta ao banco de dados (find_by).
  #   - Define o ID do usuário na sessão (session[:user_id]) em caso de sucesso.
  #   - Define mensagens flash (notice ou alert).
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

  # Encerra a sessão atual do usuário (Logout).
  #
  # Args: Nenhum
  # Retorno: Redireciona para a tela de login (login_path).
  # Efeitos Colaterais:
  #   - Remove o ID do usuário da sessão (session[:user_id] = nil).
  #   - Define mensagem flash de sucesso.
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Deslogado.'
  end
end