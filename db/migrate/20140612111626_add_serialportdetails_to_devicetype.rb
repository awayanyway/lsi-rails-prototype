class AddSerialportdetailsToDevicetype < ActiveRecord::Migration
  def change
    add_column :devicetypes, :portdatabits, :integer, :default => 8
    add_column :devicetypes, :portparity, :string, :default => "none"
    add_column :devicetypes, :portstopbits, :integer, :default => 1
    add_column :devicetypes, :portlinebreak, :string, :default => "0A"
    add_column :devicetypes, :portprefix, :string, :default => ""
    add_column :devicetypes, :portsuffix, :string, :default => ""
  end
end
