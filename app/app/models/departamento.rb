# Representa um Departamento da universidade (ex: Ciência da Computação, Matemática).
# Atua como uma entidade organizadora que agrupa as matérias ofertadas.
class Departamento < ApplicationRecord
  # Associações:
  # Um departamento é responsável por ofertar várias matérias.
  has_many :materias
end