class CreateNodedata < ActiveRecord::Migration[6.1]
  def change
    create_table :nodedata do |t|
      t.string :name, :primary_key
      t.string :code_environment
      t.jsonb :classes
      t.jsonb :trusted_data
      t.timestamps
    end

    add_index :nodedata, :name
  end
end
