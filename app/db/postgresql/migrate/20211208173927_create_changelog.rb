class CreateChangelog < ActiveRecord::Migration[6.1]
  def change
    create_table :changelog, id: :uuid do |t|
      t.string :username
      t.string :object_type
      t.string :object_id
      t.jsonb :change_details
      t.timestamps
    end

    add_index :changelog, :username
  end
end
