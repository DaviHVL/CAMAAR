# Modelo de associação (Join Model) responsável por vincular Usuários (alunos ou professores) às Turmas.
# Implementa o relacionamento N:N (Muitos-para-Muitos) entre essas duas entidades.
#
# Cada registro nesta tabela representa uma "matrícula" ou "atribuição" de um usuário
# em uma turma específica do semestre.
class UsuarioTurma < ApplicationRecord
  # Associações:
  # - usuario: O aluno matriculado ou professor alocado.
  # - turma: A turma específica (matéria/horário) onde o vínculo ocorre.
  belongs_to :usuario
  belongs_to :turma
end