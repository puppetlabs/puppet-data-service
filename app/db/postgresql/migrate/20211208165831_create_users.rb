class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:users, primary_key: [:username]) do |t|
      t.string :username, null: false
      t.string :email
      t.string :role
      t.string :status
      t.string :temp_token
      t.timestamps
    end

    add_index :users, :temp_token
  end
end
