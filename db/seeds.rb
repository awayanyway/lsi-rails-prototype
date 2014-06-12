# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Devicetype.delete_all
if (!Devicetype.exists?(:deviceclass_id => 1)) then Devicetype.create :deviceclass_id => 1, :showcase => true, :name => "knf_sc920", :displayname => "KNF SC920", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "115200", :portlinebreak => "0A", :portstartbits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0A" end
if (!Devicetype.exists?(:deviceclass_id => 2)) then Devicetype.create :deviceclass_id => 2, :showcase => true, :name => "heidolph", :displayname => "Heidolph Hei-Vac", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "115200", :portlinebreak => "0A", :portstartbits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "" end
if (!Devicetype.exists?(:deviceclass_id => 3)) then Devicetype.create :deviceclass_id => 3, :showcase => true, :name => "kern", :displayname => "Kern Balance", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200", :portlinebreak => "0A", :portstartbits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "", :portsuffix => "0A" end

if (!Devicetype.exists?(:deviceclass_id => 4)) then Devicetype.create :deviceclass_id => 4, :showcase => false, :name => "legacy_vnc", :displayname => "Legacy via VNC", :porttype => "vnc", :portname => "", :portbaud => "", :portlinebreak => "" end
if (!Devicetype.exists?(:deviceclass_id => 5)) then Devicetype.create :deviceclass_id => 5, :showcase => false, :name => "purebeaglebone", :displayname => "BeagleBone", :porttype => "serial", :portname => "", :portbaud => "", :portlinebreak => "" end
if (!Devicetype.exists?(:deviceclass_id => 6)) then Devicetype.create :deviceclass_id => 6, :showcase => false, :name => "weathercape", :displayname => "BeagleBone", :porttype => "embedded", :portname => "", :portbaud => "", :portlinebreak => "" end

if (!Devicetype.exists?(:deviceclass_id => 7)) then Devicetype.create :deviceclass_id => 7, :showcase => false, :name => "knf_simdos_02", :displayname => "KNF SIMDOS 02", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "9600", :portlinebreak => "", :portstartbits => 8, :portparity => "none", :portstopbits => 1, :portprefix => "023030", :portsuffix => "0355" end
if (!Devicetype.exists?(:deviceclass_id => 8)) then Devicetype.create :deviceclass_id => 8, :showcase => false, :name => "denver_summit", :displayname => "Denver Instrument S/SI Summit", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200", :portlinebreak => "0D", :portstartbits => 7, :portparity => "odd", :portstopbits => 1, :portprefix => "", :portsuffix => "" end
if (!Devicetype.exists?(:deviceclass_id => 9)) then Devicetype.create :deviceclass_id => 9, :showcase => false, :name => "ika_ret_control", :displayname => "IKA RET control", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "9600", :portlinebreak => "0D0A", :portstartbits => 7, :portparity => "odd", :portstopbits => 1, :portprefix => "", :portsuffix => "0D0A" end