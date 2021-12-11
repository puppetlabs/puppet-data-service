class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table(:nodes, primary_key: :name) do |t|
      t.string :code_environment
      t.jsonb :classes
      t.jsonb :trusted_data
      t.timestamps
    end
  end
end
