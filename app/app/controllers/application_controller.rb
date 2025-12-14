# Controlador base da aplicação. Define métodos auxiliares de autenticação
# e sessão que são compartilhados por todos os outros controllers.
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  # Retorna a instância do usuário logado na sessão atual (memoized).
  # Utiliza a técnica de memoization para evitar múltiplas consultas ao banco na mesma requisição.
  #
  # Args: Nenhum
  # Retorno:
  #   - Objeto (Usuario): Se houver um usuário logado.
  #   - nil: Se não houver usuário na sessão.
  # Efeitos Colaterais: Realiza consulta ao banco de dados (Usuario.find) na primeira chamada.
  def current_user
    @current_user ||= Usuario.find(session[:user_id]) if session[:user_id]
  end

  # Verifica se há um usuário autenticado no sistema.
  #
  # Args: Nenhum
  # Retorno: Boolean (true se logado, false caso contrário).
  # Efeitos Colaterais: Nenhum.
  def logged_in?
    !!current_user
  end

  # Filtro (callback) utilizado para bloquear o acesso a páginas restritas.
  # Deve ser usado em 'before_action' nos controllers que exigem autenticação.
  #
  # Args: Nenhum
  # Retorno:
  #   - nil: Se o usuário estiver logado (permite o fluxo continuar).
  #   - Redirecionamento: Se o usuário não estiver logado.
  # Efeitos Colaterais:
  #   - Interrompe a execução da action atual.
  #   - Redireciona o navegador para a rota login_path.
  #   - Define uma mensagem de alerta (flash[:alert]).
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end
end