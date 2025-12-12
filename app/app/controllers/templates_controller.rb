# Gerencia as operações de CRUD (Criação, Leitura, Atualização e Exclusão)
# para os Templates de avaliação. Permite que administradores configurem
# questionários base que serão clonados para as turmas.
class TemplatesController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  before_action :load_and_authorize_template, only: %i[edit update destroy]

  def index
    @templates = Template.all.order(created_at: :desc)
  end

  def new
    @template = Template.new
    @template.build_initial_structure
  end

  def create
    @template = Template.new(template_params)
    @template.usuario = current_user
    handle_persistence(@template, :new, "criado")
  end

  def edit
    @template.build_initial_structure if @template.questao_templates.empty?
  end

  def update
    @template.assign_attributes(template_params)
    handle_persistence(@template, :edit, "atualizado")
  end

  def destroy
    nome = @template.nome
    @template.destroy
    redirect_to templates_path, notice: "Template '#{nome}' excluído com sucesso."
  end

  private

  def handle_persistence(template, render_view, success_action)
    if template.save
      redirect_to templates_path, notice: "Template #{success_action} com sucesso!"
    else
      flash.now[:alert] = "Erro ao salvar template. Verifique os campos."
      render render_view, status: :unprocessable_entity
    end
  end

  def template_params
    params.require(:template).permit(
      :nome,
      questao_templates_attributes: [
        :id, :texto_questao, :tipo_resposta, :_destroy,
        { opcao_templates_attributes: %i[id texto_opcao numero_opcao _destroy] }
      ]
    )
  end

  def load_and_authorize_template
    @template = Template.includes(questao_templates: :opcao_templates).find(params[:id])

    return if @template.usuario_id == current_user.id

    redirect_to templates_path, alert: "Você não tem permissão para acessar este template."
  end

  def handle_not_found
    redirect_to templates_path, alert: "Template não encontrado."
  end
end