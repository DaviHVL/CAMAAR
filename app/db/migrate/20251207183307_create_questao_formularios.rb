class CreateQuestaoFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :questao_formularios do |t|
      t.text :texto_questao
      t.string :tipo_resposta
      t.references :formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
