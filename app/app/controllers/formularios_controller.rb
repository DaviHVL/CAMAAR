# Gerencia a exibição e o recebimento de respostas de formulários pelos alunos.
# Responsável por intermediar a interação do usuário com as avaliações pendentes.
class FormulariosController < ApplicationController
  before_action :require_login
  before_action :set_formulario, only: [:show, :responder]

  # Exibe a interface do formulário de avaliação para que o aluno possa responder.
  #
  # Args:
  #   - params[:id] (Integer): ID do formulário (via set_formulario).
  #   - params[:turma_id] (Integer): ID da turma à qual a avaliação pertence.
  # Retorno: Renderiza a view 'show' com @formulario e @turma_id definidos.
  # Efeitos Colaterais: Nenhuma alteração no banco, apenas leitura.
  def show
    @turma_id = params[:turma_id]
  end

  # Processa e salva as respostas enviadas pelo aluno.
  # Delega a lógica de persistência para o serviço FormResponseService.
  #
  # Args:
  #   - params[:respostas] (Hash): Mapa contendo { questao_id => resposta_valor }.
  #   - current_user (Usuario): Usuário logado submetendo a resposta.
  # Retorno: Redireciona para dashboard_path com mensagem de sucesso ou erro.
  # Efeitos Colaterais:
  #   - Persiste os registros de resposta no banco de dados via Service Object.
  #   - Define mensagens flash (notice/alert).
  def responder
    FormResponseService.new(current_user, @formulario, params[:respostas]).call

    redirect_to dashboard_path, notice: "Avaliação enviada com sucesso!"
  rescue ActiveRecord::RecordInvalid
    redirect_to dashboard_path, alert: "Erro ao salvar avaliação."
  end

  private

  # Callback executado antes das ações para carregar o formulário.
  #
  # Args:
  #   - params[:id] (Integer): ID do formulário na URL.
  # Retorno: Objeto Formulario.
  # Efeitos Colaterais: Realiza consulta ao banco de dados (find).
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end