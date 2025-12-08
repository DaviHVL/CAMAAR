class EvaluationCardComponent < ViewComponent::Base
  def initialize(turma:, materia:, professor:, semestre:, formulario_id: nil, turma_id: nil)
    @turma = turma
    @materia = materia
    @professor = professor || "Professor não atribuído"
    @semestre = semestre
    @formulario_id = formulario_id
    @turma_id = turma_id
  end
end