# spec/system/login_spec.rb
require 'rails_helper'

RSpec.describe "Autenticação", type: :system do
  before do
    # Garante que as rotas e componentes carreguem corretamente
    driven_by(:rack_test) 
  end

  it "permite que um usuário existente faça login com sucesso" do
    # 1. PREPARAR (Cria o dado no banco)
    Usuario.create!(
      nome: "Aluno Teste",
      email: "aluno@unb.br", 
      password: "password123",
      matricula: "231013529"
    )

    # 2. AGIR (Simula o navegador)
    visit login_path
    
    fill_in "Email", with: "aluno@unb.br"
    fill_in "Senha", with: "password123"
    click_button "Entrar"

    # 3. VERIFICAR (Expectativas)
    expect(page).to have_content("Logado com sucesso!")
    expect(current_path).to eq(root_path)
  end

  it "exibe erro com credenciais inválidas" do
    visit login_path
    
    fill_in "Email", with: "errado@unb.br"
    fill_in "Senha", with: "senhaerrada"
    click_button "Entrar"

    expect(page).to have_content("Email ou senha inválidos")
  end
end