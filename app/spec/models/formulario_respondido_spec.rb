require 'rails_helper'

RSpec.describe FormularioRespondido, type: :model do
  it 'instancia corretamente' do
    expect(FormularioRespondido.new).to be_a(FormularioRespondido)
  end
end
