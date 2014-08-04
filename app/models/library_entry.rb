class LibraryEntry < ActiveRecord::Base
  attr_accessible :library_id, :position, :molecule_id, :sample_id, :lename

  belongs_to :sample


  belongs_to :library
  acts_as_list scope: :library

  def name

  	if lename.nil? then sample.name else lename end
  		
  end
end
