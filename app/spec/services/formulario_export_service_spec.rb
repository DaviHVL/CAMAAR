require 'rails_helper'

RSpec.describe FormularioExportService do
  let(:aluno) { Usuario.create!(nome: "Aluno CSV", email: "csv@teste.com", matricula: "111", ocupacao: "discente", password: "123", password_confirmation: "123") }
  let(:formulario) { Formulario.create!(titulo: "Form CSV") }
  let(:questao) { QuestaoFormulario.create!(formulario: formulario, texto_questao: "Gostou?", tipo_resposta: "texto") }
  
  before do
    respondido = FormularioRespondido.create!(formulario: formulario, usuario: aluno)
    QuestaoRespondida.create!(formulario_respondido: respondido, questao_formulario: questao, resposta: "Sim, adorei")
  end

  describe "#call" do
    it "gera o conteúdo CSV com cabeçalhos e respostas" do
      service = described_class.new(formulario)
      csv_result = service.call

      expect(csv_result).to be_kind_of(String)
      
      expect(csv_result).to include("Matrícula,Nome,Gostou?")
      
      expect(csv_result).to include("111")
      expect(csv_result).to include("Aluno CSV")
      expect(csv_result).to include("Sim, adorei")
    end

    it "funciona mesmo sem respostas (apenas cabeçalhos)" do
      formulario_vazio = Formulario.create!(titulo: "Vazio")
      service = described_class.new(formulario_vazio)
      csv_result = service.call

      expect(csv_result).to include("Matrícula,Nome")
    end
  end
end