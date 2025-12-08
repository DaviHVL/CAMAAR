# db/seeds.rb

puts "🌱 Iniciando o seed do banco de dados..."

# 1. Limpar dados existentes (na ordem reversa para não quebrar FKs)
puts "🧹 Limpando tabelas antigas..."
QuestaoRespondida.destroy_all
FormularioRespondido.destroy_all
OpcaoFormulario.destroy_all
QuestaoFormulario.destroy_all
FormularioTurma.destroy_all
Formulario.destroy_all
OpcaoTemplate.destroy_all
QuestaoTemplate.destroy_all
Template.destroy_all
UsuarioTurma.destroy_all
Turma.destroy_all
Materia.destroy_all
Departamento.destroy_all
Usuario.destroy_all

# 2. Criar Usuários
puts "👤 Criando usuários..."

# Admin
admin = Usuario.create!(
  nome: "Administrador Geral",
  email: "admin@unb.br",
  matricula: "000001",
  password: "123",
  password_confirmation: "123",
  ocupacao: "admin",
  is_admin: true
)

# Professor
prof = Usuario.create!(
  nome: "Prof. Pardal",
  email: "pardal@unb.br",
  matricula: "000002",
  password: "123",
  password_confirmation: "123",
  ocupacao: "docente",
  is_admin: false
)

# Alunos
alunos = []
5.times do |i|
  alunos << Usuario.create!(
    nome: "Aluno #{i + 1}",
    email: "aluno#{i + 1}@unb.br",
    matricula: "202300#{i + 1}",
    password: "123",
    password_confirmation: "123",
    ocupacao: "discente",
    is_admin: false
  )
end

# 3. Estrutura Acadêmica
puts "🏫 Criando estrutura acadêmica..."

dep_cic = Departamento.create!(nome: "Ciência da Computação")
dep_mat = Departamento.create!(nome: "Matemática")

mat_bd = Materia.create!(nome: "Bancos de Dados", codigo: "CIC0097", departamento: dep_cic)
mat_es = Materia.create!(nome: "Engenharia de Software", codigo: "CIC0105", departamento: dep_cic)
mat_calc = Materia.create!(nome: "Cálculo 1", codigo: "MAT001", departamento: dep_mat)

turma_bd = Turma.create!(num_turma: "TA", semestre: "2024.1", materia: mat_bd)
turma_es = Turma.create!(num_turma: "TB", semestre: "2024.1", materia: mat_es)

# 4. Matrículas (Vínculos)
puts "🔗 Vinculando usuários às turmas..."

# Professor nas duas turmas
UsuarioTurma.create!(usuario: prof, turma: turma_bd)
UsuarioTurma.create!(usuario: prof, turma: turma_es)

# Alunos nas turmas (misturado)
alunos.each_with_index do |aluno, index|
  UsuarioTurma.create!(usuario: aluno, turma: turma_bd)
  UsuarioTurma.create!(usuario: aluno, turma: turma_es) if index.even? # Só alguns em ES
end

# 5. Templates e Formulários
puts "📝 Criando templates e formulários..."

# Template
template = Template.create!(nome: "Avaliação Padrão CIC", usuario: admin)

# Questão de Texto
q1 = QuestaoTemplate.create!(
  texto_questao: "O que você achou da didática do professor?",
  tipo_resposta: "texto",
  template: template
)

# Questão de Múltipla Escolha
q2 = QuestaoTemplate.create!(
  texto_questao: "Como você avalia a infraestrutura da sala?",
  tipo_resposta: "multipla_escolha",
  template: template
)
OpcaoTemplate.create!(texto_opcao: "Ruim", numero_opcao: 1, questao_template: q2)
OpcaoTemplate.create!(texto_opcao: "Regular", numero_opcao: 2, questao_template: q2)
OpcaoTemplate.create!(texto_opcao: "Boa", numero_opcao: 3, questao_template: q2)

# Criar um Formulário Aplicado (Cópia do Template para a Turma de BD)
form = Formulario.create!(titulo: "Avaliação Final - Bancos de Dados", so_alunos: true)
FormularioTurma.create!(formulario: form, turma: turma_bd)

# Copiar questões do template para o formulário (simulando a lógica real)
QuestaoFormulario.create!(texto_questao: q1.texto_questao, tipo_resposta: q1.tipo_resposta, formulario: form)
q_form_2 = QuestaoFormulario.create!(texto_questao: q2.texto_questao, tipo_resposta: q2.tipo_resposta, formulario: form)
OpcaoFormulario.create!(texto_opcao: "Ruim", numero_opcao: 1, questao_formulario: q_form_2)
OpcaoFormulario.create!(texto_opcao: "Regular", numero_opcao: 2, questao_formulario: q_form_2)
OpcaoFormulario.create!(texto_opcao: "Boa", numero_opcao: 3, questao_formulario: q_form_2)

puts "✅ Seed concluído com sucesso!"
puts "--------------------------------------------------"
puts "Login Admin: admin@unb.br / 123"
puts "Login Prof:  pardal@unb.br / 123"
puts "Login Aluno: aluno1@unb.br / 123"
puts "--------------------------------------------------"