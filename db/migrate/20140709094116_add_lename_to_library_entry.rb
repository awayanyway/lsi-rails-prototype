class AddLenameToLibraryEntry < ActiveRecord::Migration
  def change
    add_column :library_entries, :lename, :string
  end
end
