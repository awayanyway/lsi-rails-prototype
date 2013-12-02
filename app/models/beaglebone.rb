class Beaglebone < ActiveRecord::Base
  attr_accessible :ipaddress, :serialnumber, :updateonnextboot, :version, :last_seen, :external_ip

  has_many :project_beaglebones
  has_many :projects,
  through: :project_beaglebones

  def add_to_project (project_id)

    pm = ProjectBeaglebone.new
    pm.beaglebone_id = self.id
    pm.project_id = project_id
    pm.save

  end
end
