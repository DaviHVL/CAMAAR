# Gerencia a exibição e o recebimento de respostas de formulários pelos alunos.
class FormulariosController < ApplicationController
  before_action :require_login
  before_action :set_formulario, only: [:show, :responder]

  def show
    @turma_id = params[:turma_id]
  end

  def responder
    FormResponseService.new(current_user, @formulario, params[:respostas]).call

    redirect_to dashboard_path, notice: "Avaliação enviada com sucesso!"
  rescue ActiveRecord::RecordInvalid
    redirect_to dashboard_path, alert: "Erro ao salvar avaliação."
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end