class Turma < ApplicationRecord
  belongs_to :materia
  has_many :usuario_turmas
  has_many :usuarios, through: :usuario_turmas
end