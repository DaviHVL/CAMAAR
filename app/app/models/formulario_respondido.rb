class FormularioRespondido < ApplicationRecord
  belongs_to :formulario
  belongs_to :usuario
end
