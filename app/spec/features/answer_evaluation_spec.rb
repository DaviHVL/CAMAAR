require 'rails_helper'

RSpec.describe "Responder Avaliação", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "permite que um usuário responda um formulário de avaliação" do
    # Criar usuário e efetuar login
    usuario = Usuario.create!(nome: "Aluno", email: "aluno2@unb.br", password: "senha123", matricula: "0001", ocupacao: "discente")

    # Criar turma e formulário com questões
    materia = Materia.create!(nome: "Matéria Teste")
    turma = Turma.create!(num_turma: "T1", materia: materia, semestre: "2025.2")
    
    # Associar usuário à turma
    UsuarioTurma.create!(usuario: usuario, turma: turma)
    
    formulario = Formulario.create!(titulo: "Avaliação de Teste", so_alunos: true)

    # Questão de texto
    q_texto = QuestaoFormulario.create!(formulario: formulario, texto_questao: "O que achou?", tipo_resposta: 'texto')

    # Questão de múltipla escolha
    q_multi = QuestaoFormulario.create!(formulario: formulario, texto_questao: "Avalie a disciplina", tipo_resposta: 'multipla_escolha')
    o1 = OpcaoFormulario.create!(questao_formulario: q_multi, texto_opcao: "Ruim", numero_opcao: 1)
    o2 = OpcaoFormulario.create!(questao_formulario: q_multi, texto_opcao: "Regular", numero_opcao: 2)
    o3 = OpcaoFormulario.create!(questao_formulario: q_multi, texto_opcao: "Boa", numero_opcao: 3)

    # Associar formulário à turma (opcional mas segue o padrão do app)
    FormularioTurma.create!(formulario: formulario, turma: turma)
    visit login_path
    fill_in "Email", with: usuario.email
    fill_in "Senha", with: "senha123"
    click_button "Entrar"

    # Abrir o formulário (passando turma_id como o controller espera)
    visit formulario_path(formulario, turma_id: turma.id)

    # Preencher respostas
    fill_in "respostas[#{q_texto.id}]", with: "Muito bom"
    find("input[type='radio'][value='#{o3.id}']").click

    click_button "Enviar Avaliação"

    # Expectativas
    expect(page).to have_content("Avaliação enviada com sucesso!")
    expect(current_path).to eq(dashboard_path)

    # Verificar no banco
    fr = FormularioRespondido.find_by(formulario: formulario, usuario: usuario)
    expect(fr).to be_present
    expect(fr.questao_respondidas.map(&:questao_formulario_id)).to contain_exactly(q_texto.id, q_multi.id)
  end
end
