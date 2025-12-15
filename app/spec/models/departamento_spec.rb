require 'rails_helper'

RSpec.describe Departamento, type: :model do
  subject { described_class.new(nome: 'Departamento Teste') }

  it 'é válido com atributos válidos' do
    expect(subject).to be_valid
  end

  it 'é válido mesmo sem nome' do
    expect(subject).to be_valid
  end

end
