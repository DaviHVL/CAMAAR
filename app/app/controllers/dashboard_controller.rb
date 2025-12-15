# Controlador responsável pela página inicial do usuário autenticado (Dashboard).
# Exibe informações gerais como turmas matriculadas e avaliações pendentes.
class DashboardController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  # Carrega os dados necessários para a visualização do painel do aluno/professor.
  # Busca as turmas vinculadas ao usuário e identifica quais formulários já foram respondidos.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'index' com as variáveis de instância @turmas e @ids_respondidos.
  # Efeitos Colaterais:
  #   - Realiza consulta ao banco de dados para carregar turmas e suas associações (matéria, formulários).
  #   - Executa query para listar IDs de formulários respondidos pelo usuário atual.
  def index
    @turmas = current_user.turmas.includes(:materia, :formularios)

    @ids_respondidos = current_user.formulario_respondidos.pluck(:formulario_id)
  end
end