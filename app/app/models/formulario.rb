# Representa o modelo de Formulário, contendo as definições das questões.
class Formulario < ApplicationRecord
  has_many :questao_formularios, dependent: :destroy
  has_many :formulario_respondidos, dependent: :destroy
  has_many :formulario_turmas
  has_many :turmas, through: :formulario_turmas

  def gerar_csv
    FormularioExportService.new(self).call
  end
end