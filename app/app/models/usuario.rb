# Representa os usuários do sistema (Alunos, Professores, Admins).
# Centraliza o gerenciamento de credenciais, autenticação e dados cadastrais.
#
# Atua como o núcleo de identidade da aplicação, gerenciando senhas seguras
# e relacionamentos com turmas e formulários.
class Usuario < ApplicationRecord
  # Inclui o Concern (Módulo) responsável pela lógica de "Esqueci minha senha".
  # Adiciona métodos como: send_password_reset_email, clear_reset_digest, etc.
  include PasswordResetable

  # Adiciona funcionalidade de hashing de senha usando BCrypt.
  # Injeta automaticamente os métodos: #password=, #password_confirmation= e #authenticate.
  has_secure_password

  # Validações de integridade dos dados cadastrais (Regras de Negócio):
  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :ocupacao, presence: true

  # Associações Acadêmicas:
  # Relacionamento N:N com Turmas (aluno matriculado ou professor alocado).
  has_many :usuario_turmas
  has_many :turmas, through: :usuario_turmas

  # Associações de Avaliação:
  # - formulario_respondidos: Histórico de avaliações respondidas pelo usuário.
  has_many :formulario_respondidos
  
  # - templates: Modelos de avaliação criados pelo usuário (geralmente Admin/Professor).
  has_many :templates
end