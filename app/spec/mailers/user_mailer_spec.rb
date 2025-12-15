require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:usuario) { double(email: 'teste@email.com') }
  let(:token) { 'abc123' }

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(usuario, token) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Redefinição de Senha - CAMAAR')
      expect(mail.to).to eq(['teste@email.com'])
      expect(mail.from).not_to be_nil
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(token)
    end
  end
end
