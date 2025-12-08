class Formulario < ApplicationRecord
  has_many :questao_formularios, dependent: :destroy

  has_many :formulario_respondidos, dependent: :destroy
  
  has_many :formulario_turmas
  has_many :turmas, through: :formulario_turmas
end