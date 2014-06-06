class Run < ActiveRecord::Base
	attr_accessible :measurement_id, :location_id, :user_id, :started_at, :stopped_at, :finished

  belongs_to :measurement
  belongs_to :location

	validates_uniqueness_of :location_id, :scope => [:measurement_id]
end
