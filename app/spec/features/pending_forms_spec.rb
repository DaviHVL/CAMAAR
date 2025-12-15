require 'rails_helper'

RSpec.describe "Formulários Pendentes no Dashboard", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "exibe apenas as turmas com formulários não respondidos pelo usuário" do
    # Criar usuário estudante
    usuario = Usuario.create!(nome: "Aluno Pendente", email: "pendente@unb.br", password: "senha123", matricula: "9999", ocupacao: "discente")

    # Criar departamento e matérias
    departamento = Departamento.create!(nome: "Departamento Teste")
    materia1 = Materia.create!(nome: "Banco de Dados", departamento: departamento)
    materia2 = Materia.create!(nome: "Algoritmos", departamento: departamento)

    # Criar duas turmas e associá-las ao usuário
    turma1 = Turma.create!(num_turma: "T1", materia: materia1, semestre: "2025.2")
    turma2 = Turma.create!(num_turma: "T2", materia: materia2, semestre: "2025.2")

    UsuarioTurma.create!(usuario: usuario, turma: turma1)
    UsuarioTurma.create!(usuario: usuario, turma: turma2)

    # Criar formulários e associar um a cada turma
    formulario1 = Formulario.create!(titulo: "Avaliação 1", so_alunos: true)
    formulario2 = Formulario.create!(titulo: "Avaliação 2", so_alunos: true)

    FormularioTurma.create!(formulario: formulario1, turma: turma1)
    FormularioTurma.create!(formulario: formulario2, turma: turma2)

    # Marcar o segundo formulário como já respondido pelo usuário
    fr = FormularioRespondido.create!(formulario: formulario2, usuario: usuario)

    # Login via UI
    visit login_path
    fill_in "Email", with: usuario.email
    fill_in "Senha", with: "senha123"
    click_button "Entrar"

    # Visitar dashboard
    visit dashboard_path

    # Deve mostrar a turma1 (Banco de Dados) com o badge 'Responder'
    expect(page).to have_content("Banco de Dados")
    # O cartão pode ser um <a> ou <div>, então buscamos o ancestral genérico com a classe 'block'
    within(:xpath, "//h3[text()='Banco de Dados']/ancestor::*[contains(@class,'block')]") do
      expect(page).to have_text("Responder")
    end

    # Não deve exibir a turma2 (Algoritmos) porque o formulário já foi respondido
    expect(page).not_to have_content("Algoritmos")
  end
end
