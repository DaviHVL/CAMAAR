# Representa uma disciplina ou matéria acadêmica ofertada pela universidade (ex: "Cálculo 1", "Engenharia de Software").
# É a definição do conteúdo pedagógico, que pode ser ofertado em várias turmas ao longo dos semestres.
class Materia < ApplicationRecord
  # Associações:
  # - departamento: A unidade acadêmica responsável por ofertar esta matéria.
  belongs_to :departamento

  # - turmas: As instâncias reais de oferta desta matéria (com professor, horário e semestre definidos).
  has_many :turmas
end