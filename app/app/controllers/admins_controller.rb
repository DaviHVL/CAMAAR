# Gerencia a área administrativa, incluindo dashboard, importação de dados do SIGAA
# e o fluxo de distribuição de formulários de avaliação para as turmas.
class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  # Exibe a dashboard principal do administrador.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'dashboard'.
  # Efeitos Colaterais: Nenhum.
  def dashboard; end

  # Renderiza o formulário para upload de arquivos de importação.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'import_form'.
  # Efeitos Colaterais: Nenhum.
  def import_form; end

  # Processa os arquivos JSON enviados para popular o banco de dados com dados acadêmicos.
  #
  # Args:
  #   - params[:arquivo_turmas] (ActionDispatch::Http::UploadedFile): Arquivo JSON de turmas.
  #   - params[:arquivo_membros] (ActionDispatch::Http::UploadedFile): Arquivo JSON de matrículas.
  # Retorno: Redireciona para admin_path (sucesso) ou admin_importar_form_path (erro).
  # Efeitos Colaterais: Cria/Atualiza registros de Turmas, Matérias e Usuários via SigaaService.
  def importar
    if files_present?
      process_import_files
      redirect_to admin_path, notice: "Importação realizada com sucesso!"
    else
      redirect_to admin_importar_form_path, alert: "Por favor, anexe os dois arquivos JSON."
    end
  end

  # Carrega os dados necessários para a tela de envio de formulários para turmas.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'send_forms' com @turmas e @templates carregados.
  # Efeitos Colaterais: Realiza consultas ao banco de dados.
  def send_forms
    @turmas = Turma.all
    @templates = Template.where(usuario_id: current_user.id).order(:nome)
  end

  # Processa o envio (cópia) de um template selecionado para as turmas escolhidas.
  #
  # Args:
  #   - params[:template_id] (Integer): ID do template a ser copiado.
  #   - params[:turma_ids] (Array<Integer>): Lista de IDs das turmas receptoras.
  # Retorno: Redireciona para admin_send_forms_path.
  # Efeitos Colaterais: Cria novas instâncias de Formulário, Questões e Opções via FormDistributionService.
  def process_send_forms
    template = Template.find_by(id: params[:template_id])
    turma_ids = params[:turma_ids]

    if template.blank? || turma_ids.blank?
      return redirect_to admin_send_forms_path, alert: "Selecione um template e pelo menos uma turma."
    end

    FormDistributionService.new(template, turma_ids).call

    redirect_to admin_send_forms_path, notice: "Formulários enviados com sucesso!"
  end

  private

  # Verifica se os arquivos obrigatórios para importação estão presentes nos parâmetros.
  #
  # Args:
  #   - params (Hash implícito)
  # Retorno: Boolean (true se ambos os arquivos estiverem presentes).
  # Efeitos Colaterais: Nenhum.
  def files_present?
    params[:arquivo_turmas].present? && params[:arquivo_membros].present?
  end

  # Instancia e executa o serviço de importação do SIGAA.
  #
  # Args:
  #   - params[:arquivo_turmas]
  #   - params[:arquivo_membros]
  # Retorno: O resultado da execução do serviço (void/indefinido).
  # Efeitos Colaterais: Executa lógica de negócio complexa de importação e persistência de dados.
  def process_import_files
    SigaaService.new(params[:arquivo_turmas].path, params[:arquivo_membros].path).call
  end
end