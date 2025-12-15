# Modelo de associação (Join Table) entre Formulários e Turmas.
# Representa a aplicação de uma avaliação específica em uma turma específica.
#
# É através desta tabela que o sistema sabe quais turmas devem responder
# a quais formulários.
class FormularioTurma < ApplicationRecord
  # Associações:
  # - formulario: O questionário de avaliação a ser aplicado.
  # - turma: A turma (matéria/semestre) que receberá esta avaliação.
  belongs_to :formulario
  belongs_to :turma
end