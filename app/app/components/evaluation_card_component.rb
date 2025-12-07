class EvaluationCardComponent < ViewComponent::Base
  def initialize(turma:, materia:, professor:, semestre:)
    @turma = turma
    @materia = materia
    @professor = professor || "Professor não atribuído"
    @semestre = semestre
  end
end