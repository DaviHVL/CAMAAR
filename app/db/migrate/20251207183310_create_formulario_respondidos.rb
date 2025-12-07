class CreateFormularioRespondidos < ActiveRecord::Migration[8.1]
  def change
    create_table :formulario_respondidos do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
