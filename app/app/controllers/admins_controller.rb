# Gerencia a área administrativa, incluindo dashboard, importação de dados do SIGAA
# e o fluxo de distribuição de formulários de avaliação para as turmas.
class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  def dashboard; end

  def import_form; end

  def importar
    if files_present?
      process_import_files
      redirect_to admin_path, notice: "Importação realizada com sucesso!"
    else
      redirect_to admin_importar_form_path, alert: "Por favor, anexe os dois arquivos JSON."
    end
  end

  def send_forms
    @turmas = Turma.all
    @templates = Template.where(usuario_id: current_user.id).order(:nome)
  end

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

  def files_present?
    params[:arquivo_turmas].present? && params[:arquivo_membros].present?
  end

  def process_import_files
    SigaaService.new(params[:arquivo_turmas].path, params[:arquivo_membros].path).call
  end
end