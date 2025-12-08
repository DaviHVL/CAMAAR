class ResultadosController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  def index
    # Lista apenas formulários que têm pelo menos uma resposta
    @formularios = Formulario.joins(:formulario_respondidos).distinct
  end

  def baixar
    @formulario = Formulario.find(params[:id])
    
    respond_to do |format|
      format.csv do
        send_data @formulario.gerar_csv, 
          filename: "resultados-#{Date.today}-#{@formulario.titulo.parameterize}.csv"
      end
    end
  end
end