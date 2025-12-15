require 'rails_helper'

RSpec.describe Template, type: :model do
  let(:usuario) do
    Usuario.create!(
      email: 'u@u.com',
      matricula: '123456',
      nome: 'Usuário Teste',
      ocupacao: 'docente',
      password: '123456'
    )
  end

  subject do
    described_class.new(
      nome: 'Template Teste',
      usuario: usuario
    )
  end

  it 'é válido com usuário e nome' do
    expect(subject).to be_valid
  end

  it 'é inválido sem nome' do
    subject.nome = nil
    expect(subject).not_to be_valid
  end
end
