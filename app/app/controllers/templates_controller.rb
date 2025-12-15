# Gerencia as operações de CRUD (Criação, Leitura, Atualização e Exclusão)
# para os Templates de avaliação. Permite que administradores configurem
# questionários base que serão clonados para as turmas.
class TemplatesController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  before_action :load_and_authorize_template, only: %i[edit update destroy]

  # Lista todos os templates cadastrados no sistema, ordenados por data de criação.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'index' com a variável @templates populada.
  # Efeitos Colaterais: Realiza consulta ao banco de dados (all).
  def index
    @templates = Template.all.order(created_at: :desc)
  end

  # Instancia um novo objeto Template e constrói a estrutura inicial de questões.
  # Utilizado para renderizar o formulário de criação vazio.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'new'.
  # Efeitos Colaterais: Instancia objetos em memória (Template, QuestaoTemplate, OpcaoTemplate).
  def new
    @template = Template.new
    @template.build_initial_structure
  end

  # Processa a criação de um novo template no banco de dados.
  #
  # Args:
  #   - params[:template] (Hash): Parâmetros do formulário contendo nome e questões aninhadas.
  # Retorno:
  #   - Redireciona para templates_path (sucesso).
  #   - Renderiza a view 'new' (erro).
  # Efeitos Colaterais:
  #   - Insere registros nas tabelas Template, QuestaoTemplate e OpcaoTemplate.
  #   - Define mensagens flash.
  def create
    @template = Template.new(template_params)
    @template.usuario = current_user
    handle_persistence(@template, :new, "criado")
  end

  # Exibe o formulário de edição para um template existente.
  #
  # Args:
  #   - params[:id] (Integer): ID do template (validado no before_action).
  # Retorno: Renderiza a view 'edit'.
  # Efeitos Colaterais: Pode instanciar estruturas vazias em memória se o template não tiver questões.
  def edit
    @template.build_initial_structure if @template.questao_templates.empty?
  end

  # Atualiza os atributos de um template existente.
  #
  # Args:
  #   - params[:id] (Integer): ID do template.
  #   - params[:template] (Hash): Novos dados do formulário.
  # Retorno:
  #   - Redireciona para templates_path (sucesso).
  #   - Renderiza a view 'edit' (erro).
  # Efeitos Colaterais:
  #   - Atualiza registros no banco de dados.
  #   - Define mensagens flash.
  def update
    @template.assign_attributes(template_params)
    handle_persistence(@template, :edit, "atualizado")
  end

  # Remove permanentemente um template do sistema.
  #
  # Args:
  #   - params[:id] (Integer): ID do template a ser excluído.
  # Retorno: Redireciona para templates_path.
  # Efeitos Colaterais:
  #   - Remove o registro e suas associações (questões/opções) do banco de dados.
  #   - Define mensagem flash de sucesso.
  def destroy
    nome = @template.nome
    @template.destroy
    redirect_to templates_path, notice: "Template '#{nome}' excluído com sucesso."
  end

  private

  # Método auxiliar para centralizar a lógica de salvamento e resposta (DRY).
  #
  # Args:
  #   - template (Template): A instância do objeto a ser salvo.
  #   - render_view (Symbol): A view a ser renderizada em caso de erro (:new ou :edit).
  #   - success_action (String): Verbo para mensagem de sucesso ("criado" ou "atualizado").
  # Retorno: Redirecionamento ou Renderização.
  # Efeitos Colaterais: Executa o .save no banco e define Flash messages.
  def handle_persistence(template, render_view, success_action)
    if template.save
      redirect_to templates_path, notice: "Template #{success_action} com sucesso!"
    else
      flash.now[:alert] = "Erro ao salvar template. Verifique os campos."
      render render_view, status: :unprocessable_entity
    end
  end

  # Define os parâmetros permitidos (Strong Parameters) para templates e nested attributes.
  #
  # Args: params (ActionController::Parameters)
  # Retorno: Hash permitido com a estrutura do template.
  # Efeitos Colaterais: Nenhum.
  def template_params
    params.require(:template).permit(
      :nome,
      questao_templates_attributes: [
        :id, :texto_questao, :tipo_resposta, :_destroy,
        { opcao_templates_attributes: %i[id texto_opcao numero_opcao _destroy] }
      ]
    )
  end

  # Carrega o template e verifica se o usuário atual é o dono dele.
  #
  # Args: params[:id]
  # Retorno:
  #   - nil (se autorizado).
  #   - Redireciona para templates_path (se não autorizado).
  # Efeitos Colaterais: Define @template ou interrompe a requisição.
  def load_and_authorize_template
    @template = Template.includes(questao_templates: :opcao_templates).find(params[:id])

    return if @template.usuario_id == current_user.id

    redirect_to templates_path, alert: "Você não tem permissão para acessar este template."
  end

  # Trata exceções de registro não encontrado.
  #
  # Args: Nenhum
  # Retorno: Redireciona para a listagem.
  # Efeitos Colaterais: Define mensagem flash de alerta.
  def handle_not_found
    redirect_to templates_path, alert: "Template não encontrado."
  end
end