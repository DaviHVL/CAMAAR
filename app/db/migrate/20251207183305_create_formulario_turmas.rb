class CreateFormularioTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :formulario_turmas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
