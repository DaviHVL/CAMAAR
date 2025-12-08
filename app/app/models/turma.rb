class Turma < ApplicationRecord
  belongs_to :materia
  
  has_many :usuario_turmas
  has_many :usuarios, through: :usuario_turmas
  
  has_many :formulario_turmas
  has_many :formularios, through: :formulario_turmas

  def professor
    prof = usuarios.find { |u| u.ocupacao.to_s.downcase.include?('docente') || u.ocupacao.to_s.downcase.include?('professor') }
    prof ? prof.nome : "Professor não atribuído"
  end
end