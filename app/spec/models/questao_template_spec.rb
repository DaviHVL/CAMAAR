require 'rails_helper'

RSpec.describe QuestaoTemplate, type: :model do
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

  subject do
    described_class.new(
      texto_questao: 'Questão Template',
      tipo_resposta: 'objetiva',
      template: template
    )
  end

  it 'é válida com dados mínimos' do
    expect(subject).to be_valid
  end

  it 'é inválida sem texto da questão' do
    subject.texto_questao = nil
    expect(subject).not_to be_valid
  end
end
