require 'rails_helper'


RSpec.describe Materia, type: :model do
  let(:departamento) { Departamento.create! }

  subject do
    described_class.new(
      nome: 'Banco de Dados',
      codigo: 'CIC0097',
      departamento: departamento
    )
  end

  it 'é válida com departamento' do
    expect(subject).to be_valid
  end
end
