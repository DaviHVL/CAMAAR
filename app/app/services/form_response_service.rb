# Serviço responsável por processar e salvar as respostas de um formulário.
class FormResponseService
  def initialize(user, formulario, respostas_params)
    @user = user
    @formulario = formulario
    @respostas_params = respostas_params
  end

  def call
    ActiveRecord::Base.transaction do
      resposta_geral = create_general_response
      process_answers(resposta_geral) if @respostas_params.present?
    end
  end

  private

  def create_general_response
    FormularioRespondido.create!(
      formulario: @formulario,
      usuario: @user
    )
  end

  def process_answers(resposta_geral)
    @respostas_params.each do |questao_id, valor|
      save_answer(resposta_geral, questao_id, valor)
    end
  end

  def save_answer(resposta_geral, questao_id, valor)
    questao = QuestaoFormulario.find(questao_id)
    nova_resposta = QuestaoRespondida.new(
      formulario_respondido: resposta_geral,
      questao_formulario: questao
    )

    assign_value(nova_resposta, questao.tipo_resposta, valor)
    nova_resposta.save!
  end

  def assign_value(resposta_obj, tipo, valor)
    if tipo == 'Radio'
      resposta_obj.opcao_formulario_id = valor
    else
      resposta_obj.resposta = valor
    end
  end
end