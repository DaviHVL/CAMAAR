# Controlador responsável pela visualização e exportação dos resultados
# das avaliações (formulários respondidos).
class ResultadosController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  # Lista os formulários que já possuem pelo menos uma resposta registrada.
  # Utilizado para exibir a tabela de formulários disponíveis para download de relatório.
  #
  # Args: Nenhum
  # Retorno: Renderiza a view 'index' com a variável @formularios populada.
  # Efeitos Colaterais: Executa query no banco (INNER JOIN) para filtrar apenas formulários respondidos.
  def index
    # Lista apenas formulários que têm pelo menos uma resposta
    @formularios = Formulario.joins(:formulario_respondidos).distinct
  end

  # Gera e inicia o download do arquivo CSV com os resultados consolidados de um formulário.
  #
  # Args:
  #   - params[:id] (Integer): ID do formulário cujos resultados serão exportados.
  # Retorno:
  #   - Envia um arquivo de dados (send_data) com formato CSV para o navegador.
  # Efeitos Colaterais:
  #   - Realiza consulta ao banco de dados.
  #   - Processa a geração do CSV em memória (via método gerar_csv do model).
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