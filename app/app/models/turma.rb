class Turma < ApplicationRecord
  belongs_to :materia
  has_many :usuario_turmas
  has_many :usuarios, through: :usuario_turmas
  has_many :formulario_turmas
  has_many :formularios, through: :formulario_turmas

  def professor
    # Procura um usuário vinculado a esta turma que tenha a ocupação 'docente' ou 'Professor'
    usuarios.find_by("ocupacao ILIKE ?", "%docente%") || usuarios.find_by("ocupacao ILIKE ?", "%professor%")
  end
end