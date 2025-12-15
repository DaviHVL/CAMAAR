require 'rails_helper'

RSpec.describe UsuarioTurma, type: :model do
  it 'instancia corretamente' do
    expect(UsuarioTurma.new).to be_a(UsuarioTurma)
  end
end
