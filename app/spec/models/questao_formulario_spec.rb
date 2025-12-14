require 'rails_helper'


RSpec.describe QuestaoFormulario, type: :model do
  let(:formulario) { Formulario.create!(titulo: 'Teste') }

  subject do
    described_class.new(
      formulario: formulario
    )
  end

  it 'é válida com formulário' do
    expect(subject).to be_valid
  end
end
