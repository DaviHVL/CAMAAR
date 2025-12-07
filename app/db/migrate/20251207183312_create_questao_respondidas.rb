class CreateQuestaoRespondidas < ActiveRecord::Migration[8.1]
  def change
    create_table :questao_respondidas do |t|
      t.references :formulario_respondido, null: false, foreign_key: true
      t.references :questao_formulario, null: false, foreign_key: true
      t.references :opcao_formulario, null: false, foreign_key: true
      t.text :resposta

      t.timestamps
    end
  end
end
