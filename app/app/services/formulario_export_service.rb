require 'csv'

class FormularioExportService
  def initialize(formulario)
    @formulario = formulario
    @questoes = @formulario.questao_formularios.order(:id)
  end

  def call
    CSV.generate(headers: true) do |csv|
      csv << headers

      responses_scope.each do |resposta_geral|
        csv << build_row(resposta_geral)
      end
    end
  end

  private

  def headers
    ['Matrícula', 'Nome'] + @questoes.map(&:texto_questao)
  end

  def responses_scope
    @formulario.formulario_respondidos
               .includes(:usuario, questao_respondidas: :opcao_formulario)
  end

  def build_row(resposta_geral)
    respostas_map = map_answers(resposta_geral)
    usuario = resposta_geral.usuario

    row = [usuario.matricula, usuario.nome]

    @questoes.each do |questao|
      row << extract_value(respostas_map[questao.id])
    end

    row
  end

  def map_answers(resposta_geral)
    resposta_geral.questao_respondidas.index_by(&:questao_formulario_id)
  end

  def extract_value(resposta)
    resposta&.opcao_formulario&.texto_opcao || resposta&.resposta
  end
end