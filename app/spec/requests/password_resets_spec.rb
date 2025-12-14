require "rails_helper"

RSpec.describe "PasswordResets", type: :request do
  let!(:usuario) do
    Usuario.create!(
      email: "reset@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "Reset",
      matricula: "777",
      ocupacao: "Aluno"
    )
  end

  it "cria pedido válido" do
    post "/password_resets", params: { email: usuario.email }
    expect(response).to have_http_status(:redirect)
  end

  it "falha com email inexistente" do
    post "/password_resets", params: { email: "nao@existe.com" }
    expect(response.status).to be_between(200, 302)
  end

  it "bloqueia token inválido" do
    get "/password_resets/token_invalido/edit"
    expect(response).to have_http_status(:redirect)
  end

  it "bloqueia token expirado" do
    token = usuario.generate_password_reset_token!
    usuario.update!(reset_sent_at: 3.hours.ago)

    get "/password_resets/#{token}/edit"
    expect(response).to have_http_status(:redirect)
  end
end
