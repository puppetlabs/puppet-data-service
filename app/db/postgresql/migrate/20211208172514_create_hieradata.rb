class CreateHieradata < ActiveRecord::Migration[6.1]
  def change
    create_table(:hiera_data, primary_key: [:level, :key]) do |t|
      t.string :level, null: false
      t.string :key, null: false
      t.string :value
      t.timestamps
    end

    add_index :hiera_data, :level
    add_index :hiera_data, :key
  end
end
