class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, :primary_key
      t.string :email
      t.string :role
      t.string :temp_token
      t.timestamps
    end
    
    add_index :users, :username
  end
end
