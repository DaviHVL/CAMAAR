class AddResetToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :reset_digest, :string
    add_column :usuarios, :reset_sent_at, :datetime
  end
end
