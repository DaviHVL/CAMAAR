require 'rails_helper'

RSpec.describe Usuario, type: :model do
  let(:usuario) do
    Usuario.create!(
      email: 'u@u.com',
      matricula: '123456',
      nome: 'Usuário',
      ocupacao: 'docente',
      password: '123456'
    )
  end

  it 'gera token de reset de senha' do
    token = usuario.generate_password_reset_token!
    expect(token).to be_present
    expect(usuario.reset_digest).to be_present
  end

  it 'detecta token expirado' do
    usuario.update!(reset_sent_at: 3.hours.ago)
    expect(usuario.password_reset_expired?).to be true
  end
end
