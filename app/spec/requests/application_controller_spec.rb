require "rails_helper"

RSpec.describe "ApplicationController", type: :request do
  it "redireciona quando usuário não está logado" do
    get "/admin"
    expect(response).to have_http_status(:redirect)
  end
end
