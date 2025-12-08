class ChangeOpcaoNullableInQuestaoRespondidas < ActiveRecord::Migration[8.1] 
  def change
    change_column_null :questao_respondidas, :opcao_formulario_id, true
  end
end
