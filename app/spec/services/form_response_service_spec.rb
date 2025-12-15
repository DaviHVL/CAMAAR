require 'rails_helper'

RSpec.describe FormResponseService do
  let(:aluno) { Usuario.create!(nome: "Aluno", email: "a@a.com", matricula: "2", ocupacao: "discente", password: "123", password_confirmation: "123") }
  let(:form) { Formulario.create!(titulo: "Form Teste") }
  
  let!(:q_texto) { QuestaoFormulario.create!(formulario: form, texto_questao: "Dissertativa", tipo_resposta: "Texto") }
  
  let!(:q_radio) { QuestaoFormulario.create!(formulario: form, texto_questao: "Múltipla", tipo_resposta: "Radio") }
  let!(:opcao) { OpcaoFormulario.create!(questao_formulario: q_radio, texto_opcao: "Op1", numero_opcao: 1) }

  describe "#call" do
    it "salva respostas de texto e múltipla escolha corretamente" do
      params = {
        q_texto.id.to_s => "Minha resposta texto",
        q_radio.id.to_s => opcao.id.to_s
      }

      service = described_class.new(aluno, form, params)

      expect { service.call }
        .to change(FormularioRespondido, :count).by(1)
        .and change(QuestaoRespondida, :count).by(2)

      resp_geral = FormularioRespondido.last
      
      resp_texto = resp_geral.questao_respondidas.find_by(questao_formulario: q_texto)
      expect(resp_texto.resposta).to eq("Minha resposta texto")
      
      resp_radio = resp_geral.questao_respondidas.find_by(questao_formulario: q_radio)
      expect(resp_radio.opcao_formulario_id).to eq(opcao.id)
    end
  end
end