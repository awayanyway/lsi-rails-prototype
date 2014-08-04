class AddAncestorToSample < ActiveRecord::Migration
  def change
    add_column :samples, :ancestor_id, :integer
  end
end
