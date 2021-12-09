class CreateHieradata < ActiveRecord::Migration[6.1]
  def change
    create_table :hieradata, primary_key: [:level, :key] do |t|
      t.string :level
      t.string :key
      t.string :value
      t.timestamps
    end

    add_index :hieradata, :level
    add_index :hieradata, :key
  end
end
