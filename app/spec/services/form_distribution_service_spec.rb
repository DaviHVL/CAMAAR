require 'rails_helper'

RSpec.describe FormDistributionService do
  let(:departamento) { Departamento.create!(nome: "Dept Teste") }
  
  let(:admin) { Usuario.create!(nome: "Admin", email: "adm@teste.com", matricula: "1", ocupacao: "docente", password: "123", password_confirmation: "123") }
  let(:materia) { Materia.create!(nome: "Mat", codigo: "M1", departamento: departamento) }
  let(:turma_1) { Turma.create!(materia: materia, semestre: "2024.1", num_turma: "A") }
  let(:turma_2) { Turma.create!(materia: materia, semestre: "2024.1", num_turma: "B") }
  
  let(:template) { Template.create!(nome: "Template Base", usuario: admin) }
  let!(:questao) { QuestaoTemplate.create!(template: template, texto_questao: "Q1", tipo_resposta: "Radio") }
  let!(:opcao) { OpcaoTemplate.create!(questao_template: questao, texto_opcao: "Sim", numero_opcao: 1) }

  describe "#call" do
    it "clona o template e cria formulários para todas as turmas indicadas" do
      service = described_class.new(template, [turma_1.id, turma_2.id])

      expect { service.call }
        .to change(Formulario, :count).by(2)
        .and change(FormularioTurma, :count).by(2)
        .and change(QuestaoFormulario, :count).by(2)
        .and change(OpcaoFormulario, :count).by(2)

      form_gerado = Formulario.last
      expect(form_gerado.titulo).to eq(template.nome)
      expect(form_gerado.turmas).to include(turma_2)
      
      questao_gerada = form_gerado.questao_formularios.first
      expect(questao_gerada.texto_questao).to eq("Q1")
      
      opcao_gerada = questao_gerada.opcao_formularios.first
      expect(opcao_gerada.texto_opcao).to eq("Sim")
    end
  end
end