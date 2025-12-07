class CreateUsuarioTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :usuario_turmas do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
