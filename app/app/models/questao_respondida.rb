class QuestaoRespondida < ApplicationRecord
  belongs_to :formulario_respondido
  belongs_to :questao_formulario
  belongs_to :opcao_formulario
end
