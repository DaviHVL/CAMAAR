# Controlador responsável pelo cadastro de novos usuários no sistema (Sign Up).
class UsersController < ApplicationController
  
  # Exibe o formulário de cadastro para um novo usuário.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'new' com a variável @usuario inicializada.
  # Efeitos Colaterais: Instancia um objeto Usuario em memória.
  def new
    @usuario = Usuario.new 
  end

  # Processa os dados do formulário de cadastro e cria o usuário no banco.
  # Se bem-sucedido, realiza o login automático do usuário.
  #
  # Args:
  #   - params[:usuario] (Hash): Atributos do usuário (nome, email, senha, etc).
  # Retorno:
  #   - Redireciona para root_path (sucesso).
  #   - Renderiza a view 'new' com status unprocessable_entity (erro).
  # Efeitos Colaterais:
  #   - Cria um novo registro na tabela usuarios.
  #   - Define a sessão do usuário (session[:user_id]).
  #   - Define mensagens flash (notice/alert).
  def create
    @usuario = Usuario.new(user_params) 
    
    if @usuario.save
      session[:user_id] = @usuario.id
      flash[:notice] = "Cadastro realizado com sucesso!"
      redirect_to root_path 
    else
      flash.now[:alert] = "Não foi possível realizar o cadastro."
      render :new, status: :unprocessable_entity 
    end
  end
  
  private
  
  # Filtra os parâmetros permitidos para o cadastro de usuário (Strong Parameters).
  #
  # Args: params (ActionController::Parameters)
  # Retorno: Hash contendo apenas os atributos permitidos para Usuario.
  # Efeitos Colaterais: Nenhum.
  def user_params
    params.require(:usuario).permit(:nome, :email, :matricula, :password, :password_confirmation, :ocupacao) 
  end
end