require 'rails_helper'

RSpec.describe OpcaoTemplate, type: :model do
  let(:usuario) do
    Usuario.create!(
      email: 'u@u.com',
      matricula: '123456',
      nome: 'Usuário Teste',
      ocupacao: 'docente',
      password: '123456'
    )
  end

  let(:template) do
    Template.create!(
      nome: 'Template Teste',
      usuario: usuario
    )
  end

  let(:questao_template) do
    QuestaoTemplate.create!(
      texto_questao: 'Questão',
      tipo_resposta: 'objetiva',
      template: template
    )
  end

  subject do
    described_class.new(
      texto_opcao: 'Opção A',
      numero_opcao: 1,
      questao_template: questao_template
    )
  end

  it 'é válida com dados mínimos' do
    expect(subject).to be_valid
  end

  it 'é inválida sem texto da opção' do
    subject.texto_opcao = nil
    expect(subject).not_to be_valid
  end
end
