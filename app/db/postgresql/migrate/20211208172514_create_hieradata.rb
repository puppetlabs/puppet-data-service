class CreateHieradata < ActiveRecord::Migration[6.1]
  def change
    create_table(:hiera_data, primary_key: [:level, :key]) do |t|
      t.string :level
      t.string :key
      t.string :value
      t.timestamps
    end

    add_index :hiera_data, :level
    add_index :hiera_data, :key
  end
end
