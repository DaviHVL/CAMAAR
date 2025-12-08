# app/controllers/users_controller.rb
class UsersController < ApplicationController
  
  def new
    # CORREÇÃO 1: Usar @usuario para refletir o nome do Modelo 'Usuario'
    @usuario = Usuario.new 
  end

  def create
    # CORREÇÃO 2: Usar @usuario ao criar a instância
    @usuario = Usuario.new(user_params) 
    
    if @usuario.save
      # CORREÇÃO 3: Usar @usuario ao salvar na sessão
      session[:user_id] = @usuario.id
      flash[:notice] = "Cadastro realizado com sucesso!"
      redirect_to root_path 
    else
      # Se falhar, re-renderiza o formulário :new, usando @usuario
      flash.now[:alert] = "Não foi possível realizar o cadastro."
      render :new, status: :unprocessable_entity 
    end
  end
  
  private
  
  def user_params
    # CORREÇÃO 4: O Rails espera que o nome do recurso seja pluralizado e snake_cased
    # Se o nome do seu modelo é 'Usuario', ele deve vir como 'usuario' no params
    # Mantenha o params.require(:user) se você não quiser mudar a view.
    # Mas o mais correto para o modelo 'Usuario' é params.require(:usuario)
    params.require(:usuario).permit(:nome, :email, :matricula, :password, :password_confirmation, :ocupacao) 
  end
end