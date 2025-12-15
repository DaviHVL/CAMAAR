require 'rails_helper'

RSpec.describe FormularioTurma, type: :model do
  it 'instancia corretamente' do
    expect(FormularioTurma.new).to be_a(FormularioTurma)
  end
end
