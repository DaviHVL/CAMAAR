# Representa uma turma específica de uma matéria (disciplina) ofertada em um semestre.
# É a unidade organizacional que agrupa os alunos matriculados e o professor responsável,
# servindo de ponto de aplicação para os formulários de avaliação.
class Turma < ApplicationRecord
  # Associações:
  # - materia: A disciplina pedagógica (conteúdo) desta turma (ex: "Cálculo 1").
  belongs_to :materia
  
  # - usuarios: Lista de alunos e professores vinculados a esta turma.
  has_many :usuario_turmas
  has_many :usuarios, through: :usuario_turmas
  
  # - formularios: Avaliações que foram distribuídas para esta turma responder.
  has_many :formulario_turmas
  has_many :formularios, through: :formulario_turmas

  # Identifica e retorna o nome do professor responsável pela turma.
  # Realiza uma busca na lista de usuários vinculados filtrando pela ocupação.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - String: O nome do professor (se encontrado).
  #   - String: "Professor não atribuído" (se nenhum usuário com perfil docente for achado).
  #
  # Efeitos Colaterais:
  #   - Dispara uma consulta ao banco de dados para carregar a coleção de usuários da turma
  #     (caso ainda não tenha sido carregada em memória).
  def professor
    prof = usuarios.find { |u| u.ocupacao.to_s.downcase.include?('docente') || u.ocupacao.to_s.downcase.include?('professor') }
    prof ? prof.nome : "Professor não atribuído"
  end
end