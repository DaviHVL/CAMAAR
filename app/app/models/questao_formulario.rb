class QuestaoFormulario < ApplicationRecord
  belongs_to :formulario
  has_many :opcao_formularios, dependent: :destroy
  has_many :questao_respondidas
end