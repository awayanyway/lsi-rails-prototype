# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Devicetype.delete_all
if (!Devicetype.exists?(:deviceclass_id => 1)) then Devicetype.create :deviceclass_id => 1, :showcase => true, :name => "knf_sc920", :displayname => "KNF SC920", :porttype => "serial", :portname => "/dev/ttyACM0", :portbaud => "115200" end
if (!Devicetype.exists?(:deviceclass_id => 2)) then Devicetype.create :deviceclass_id => 2, :showcase => true, :name => "heidolph", :displayname => "Heidolph Hei-Vac", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "115200" end
if (!Devicetype.exists?(:deviceclass_id => 3)) then Devicetype.create :deviceclass_id => 3, :showcase => true, :name => "kern", :displayname => "Kern Balance", :porttype => "serial", :portname => "/dev/ttyUSB0", :portbaud => "1200" end
if (!Devicetype.exists?(:deviceclass_id => 4)) then Devicetype.create :deviceclass_id => 4, :showcase => false, :name => "legacy_vnc", :displayname => "Legacy via VNC", :porttype => "vnc", :portname => "", :portbaud => "" end
if (!Devicetype.exists?(:deviceclass_id => 5)) then Devicetype.create :deviceclass_id => 5, :showcase => false, :name => "purebeaglebone", :displayname => "BeagleBone", :porttype => "serial", :portname => "", :portbaud => "" end
if (!Devicetype.exists?(:deviceclass_id => 6)) then Devicetype.create :deviceclass_id => 6, :showcase => false, :name => "weathercape", :displayname => "BeagleBone", :porttype => "serial", :portname => "", :portbaud => "" end
