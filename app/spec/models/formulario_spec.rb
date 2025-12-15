require 'rails_helper'

RSpec.describe Formulario, type: :model do
  subject { described_class.new(titulo: 'Formulario Teste') }

  it 'é válido com título' do
    expect(subject).to be_valid
  end

  it 'é válido mesmo sem nome' do
    expect(subject).to be_valid
  end
end
