class AddFwrootToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :fwroot, :string
  end
end
