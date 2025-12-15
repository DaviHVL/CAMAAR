require 'rails_helper'

RSpec.describe Turma, type: :model do
  let(:departamento) { Departamento.create! }
  let(:materia) do
    Materia.create!(
      nome: 'Banco de Dados',
      codigo: 'CIC0097',
      departamento: departamento
    )
  end

  subject do
    described_class.new(
      materia: materia
    )
  end

  it 'é válida com matéria' do
    expect(subject).to be_valid
  end
end

