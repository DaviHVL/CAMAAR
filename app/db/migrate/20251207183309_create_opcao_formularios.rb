class CreateOpcaoFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :opcao_formularios do |t|
      t.string :texto_opcao
      t.integer :numero_opcao
      t.references :questao_formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
