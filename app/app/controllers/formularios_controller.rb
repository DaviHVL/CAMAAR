class FormulariosController < ApplicationController
  before_action :require_login

  def show
    @formulario = Formulario.find(params[:id])
    @turma_id = params[:turma_id] 
  end

  def responder
    @formulario = Formulario.find(params[:id])
    turma = Turma.find(params[:turma_id])

    resposta_geral = FormularioRespondido.create!(
      formulario: @formulario,
      usuario: current_user
    )

    params[:respostas]&.each do |questao_id, valor_resposta|
      questao = QuestaoFormulario.find(questao_id)
      
      nova_resposta = QuestaoRespondida.new(
        formulario_respondido: resposta_geral,
        questao_formulario: questao
      )

      if questao.tipo_resposta == 'Radio'
        nova_resposta.opcao_formulario_id = valor_resposta
      else
        nova_resposta.resposta = valor_resposta
      end

      nova_resposta.save!
    end

    redirect_to dashboard_path, notice: "Avaliação enviada com sucesso!"
  end
end