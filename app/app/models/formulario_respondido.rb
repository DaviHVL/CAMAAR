class FormularioRespondido < ApplicationRecord
  belongs_to :formulario
  belongs_to :usuario

  has_many :questao_respondidas, dependent: :destroy
  
  accepts_nested_attributes_for :questao_respondidas
end
