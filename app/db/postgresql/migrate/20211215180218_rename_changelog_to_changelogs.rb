class RenameChangelogToChangelogs < ActiveRecord::Migration[6.1]
  def change
    remove_index :changelog, :username
    rename_table :changelog, :changelogs
    add_index :changelogs, :username
  end
end
