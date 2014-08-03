# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Devicetype.delete_all
if (!Devicetype.exists?(:deviceclass_id => 1)) then
	Devicetype.create :deviceclass_id => 1, :showcase => true, :name => "knf_sc920", :displayname => "KNF SC920", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "115200", :portlinebreak => "0D", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D"
else
	Devicetype.where(["deviceclass_id = ?", 1]).first.update_attributes(:showcase => true, :name => "knf_sc920", :displayname => "KNF SC920", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "115200", :portlinebreak => "0D", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D")
end

if (!Devicetype.exists?(:deviceclass_id => 2)) then
	Devicetype.create :deviceclass_id => 2, :showcase => true, :name => "heidolph", :displayname => "Heidolph Hei-Vac", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "115200", :portlinebreak => "0A", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => ""
else
	Devicetype.where(["deviceclass_id = ?", 2]).first.update_attributes(:showcase => true, :name => "heidolph", :displayname => "Heidolph Hei-Vac", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "115200", :portlinebreak => "0A", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "")
end

if (!Devicetype.exists?(:deviceclass_id => 3)) then
	Devicetype.create :deviceclass_id => 3, :showcase => true, :name => "kern", :displayname => "Kern Balance", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200", :portlinebreak => "0A", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0A"
else
	Devicetype.where(["deviceclass_id = ?", 3]).first.update_attributes(:showcase => true, :name => "kern", :displayname => "Kern Balance", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200", :portlinebreak => "0A", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0A")
end


if (!Devicetype.exists?(:deviceclass_id => 4)) then
	Devicetype.create :deviceclass_id => 4, :showcase => false, :name => "legacy_vnc", :displayname => "Legacy via VNC", :porttype => "vnc", :portname => "", :portbaud => "", :portlinebreak => ""
else
	Devicetype.where(["deviceclass_id = ?", 4]).first.update_attributes(:showcase => false, :name => "legacy_vnc", :displayname => "Legacy via VNC", :porttype => "vnc", :portname => "", :portbaud => "", :portlinebreak => "")
end

if (!Devicetype.exists?(:deviceclass_id => 5)) then
	Devicetype.create :deviceclass_id => 5, :showcase => false, :name => "purebeaglebone", :displayname => "BeagleBone", :porttype => "none", :portname => "", :portbaud => "", :portlinebreak => ""
else
	Devicetype.where(["deviceclass_id = ?", 5]).first.update_attributes(:showcase => false, :name => "purebeaglebone", :displayname => "BeagleBone", :porttype => "none", :portname => "", :portbaud => "", :portlinebreak => "")
end

if (!Devicetype.exists?(:deviceclass_id => 6)) then
	Devicetype.create :deviceclass_id => 6, :showcase => false, :name => "weathercape", :displayname => "BeagleBone", :porttype => "embedded", :portname => "", :portbaud => "", :portlinebreak => ""
else
	Devicetype.where(["deviceclass_id = ?", 6]).first.update_attributes(:showcase => false, :name => "weathercape", :displayname => "BeagleBone", :porttype => "embedded", :portname => "", :portbaud => "", :portlinebreak => "")
end

if (!Devicetype.exists?(:deviceclass_id => 7)) then
	Devicetype.create :deviceclass_id => 7, :showcase => true, :name => "knf_simdos_02", :displayname => "KNF SIMDOS 02", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "9600", :portlinebreak => "knfsimdos", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "023030", :portsuffix => "0355"
else
	Devicetype.where(["deviceclass_id = ?", 7]).first.update_attributes(:showcase => true, :name => "knf_simdos_02", :displayname => "KNF SIMDOS 02", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "9600", :portlinebreak => "knfsimdos", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "023030", :portsuffix => "0355")
end

if (!Devicetype.exists?(:deviceclass_id => 8)) then
	Devicetype.create :deviceclass_id => 8, :showcase => false, :name => "denver_summit", :displayname => "Denver Instrument S/SI Summit", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200", :portlinebreak => "0D", :portdatabits => 7, :portparity => "odd", :portstopbits => 1, :portprefix => "", :portsuffix => ""
else
	Devicetype.where(["deviceclass_id = ?", 8]).first.update_attributes(:showcase => false, :name => "denver_summit", :displayname => "Denver Instrument S/SI Summit", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200", :portlinebreak => "0D", :portdatabits => 7, :portparity => "odd", :portstopbits => 1, :portprefix => "", :portsuffix => "")
end

if (!Devicetype.exists?(:deviceclass_id => 9)) then
	Devicetype.create :deviceclass_id => 9, :showcase => true, :name => "ika_ret_control", :displayname => "IKA RET control", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "9600", :portlinebreak => "0D0A", :portdatabits => 7, :portparity => "odd", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A"
else
	Devicetype.where(["deviceclass_id = ?", 9]).first.update_attributes(:showcase => true, :name => "ika_ret_control", :displayname => "IKA RET control", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "9600", :portlinebreak => "0D0A", :portdatabits => 7, :portparity => "odd", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A")
end

if (!Devicetype.exists?(:deviceclass_id => 10)) then
	Devicetype.create :deviceclass_id => 10, :showcase => true, :name => "pce_balance", :displayname => "PCE Balance", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "9600", :portlinebreak => "0D0A", :portdatabits => 7, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A"
else
	Devicetype.where(["deviceclass_id = ?", 10]).first.update_attributes(:showcase => true, :name => "pce_balance", :displayname => "PCE Balance", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "9600", :portlinebreak => "0D0A", :portdatabits => 7, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A")
end

if (!Devicetype.exists?(:deviceclass_id => 11)) then
	Devicetype.create :deviceclass_id => 11, :showcase => true, :name => "knf_rc900", :displayname => "KNF RC900", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "57600", :portlinebreak => "0D", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D"
else
	Devicetype.where(["deviceclass_id = ?", 11]).first.update_attributes(:showcase => true, :name => "knf_rc900", :displayname => "KNF RC900", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "57600", :portlinebreak => "0D", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D")
end

if (!Devicetype.exists?(:deviceclass_id => 12)) then
	Devicetype.create :deviceclass_id => 12, :showcase => true, :name => "eppendorf_innova_42", :displayname => "Eppendorf Innova 42", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "57600", :portlinebreak => "0D0A", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A"
else
	Devicetype.where(["deviceclass_id = ?", 12]).first.update_attributes(:showcase => true, :name => "eppendorf_innova_42", :displayname => "Eppendorf Innova 42", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "57600", :portlinebreak => "0D0A", :portdatabits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A")
end