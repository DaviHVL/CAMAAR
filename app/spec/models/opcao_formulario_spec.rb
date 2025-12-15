require 'rails_helper'


RSpec.describe OpcaoFormulario, type: :model do
  let(:formulario) { Formulario.create!(titulo: 'Teste') }
  let(:questao) { QuestaoFormulario.create!(formulario: formulario) }

  subject do
    described_class.new(
      questao_formulario: questao
    )
  end

  it 'é válida com questão associada' do
    expect(subject).to be_valid
  end
end
