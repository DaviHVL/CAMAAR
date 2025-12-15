require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:usuario) do
    Usuario.create!(
      email: "sess@test.com",
      password: "123456",
      password_confirmation: "123456",
      matricula: "111",
      nome: "Sessao",
      ocupacao: "Aluno"
    )
  end

  it "abre tela de login" do
    get "/login"
    expect(response).to have_http_status(:success)
  end

  it "faz login com dados válidos" do
    post "/login", params: {
      email: usuario.email,
      password: "123456"
    }

    expect(response.status).to be_between(200, 302)
  end

  it "falha login com senha errada" do
    post "/login", params: {
        email: usuario.email,
        password: "errada"
    }

    expect(response.status).to be_between(400, 422)
  end


  it "faz logout" do
    delete "/logout"
    expect(response.status).to be_between(200, 302)
  end
end
