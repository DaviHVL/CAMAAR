require 'csv'

class Formulario < ApplicationRecord
  has_many :questao_formularios, dependent: :destroy

  has_many :formulario_respondidos, dependent: :destroy
  
  has_many :formulario_turmas
  has_many :turmas, through: :formulario_turmas

  def gerar_csv
    CSV.generate(headers: true) do |csv|
      questoes = questao_formularios.order(:id)
      headers = ['Matrícula', 'Nome'] + questoes.map(&:texto_questao)
      csv << headers

      formulario_respondidos.includes(:usuario, questao_respondidas: :opcao_formulario).each do |resposta_geral|
        linha = [
          resposta_geral.usuario.matricula,
          resposta_geral.usuario.nome
        ]

        questoes.each do |questao|
          resposta = resposta_geral.questao_respondidas.find_by(questao_formulario: questao)
          
          valor = if resposta&.opcao_formulario
                    resposta.opcao_formulario.texto_opcao 
                  else
                    resposta&.resposta 
                  end
          
          linha << valor
        end

        csv << linha
      end
    end
  end
end