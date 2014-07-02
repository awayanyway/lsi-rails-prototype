class Location < ActiveRecord::Base

  has_many :runs
  has_many :measurements, :through => :runs

  has_many :device_locations
  has_many :devices,
    :through => :device_locations, :dependent => :destroy

  def runningmeasurement

  	if runs.where(["finished = ?", false]).length > 0 then

  		runs.where(["finished = ?", false]).last.measurement

  	end

  end

  def currentrun

  	runs.where(["finished = ?", false]).last

  end

end
