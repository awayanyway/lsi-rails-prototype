class Devicetype < ActiveRecord::Base
  attr_accessible :deviceclass_id, :displayname, :name, :portbaud, :portdetails, :portname, :porttype, :showcase

  attr_accessible :portlinebreak, :portprefix, :portsuffix, :portdatabits, :portstopbits, :portparity

  has_many :devices
end
