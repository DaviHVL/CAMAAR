class Usuario < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :ocupacao, presence: true

  has_many :usuario_turmas
  has_many :turmas, through: :usuario_turmas

  has_many :formulario_respondidos
  has_many :templates
end