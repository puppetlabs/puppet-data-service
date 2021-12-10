class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.string :name, :primary_key
      t.string :code_environment
      t.jsonb :classes
      t.jsonb :trusted_data
      t.timestamps
    end

    add_index :nodes, :name
  end
end
