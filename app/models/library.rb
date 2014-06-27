class Library < ActiveRecord::Base

  attr_accessible :title

  has_many :library_entries, :order => "position ASC"

  has_many :project_libraries
  has_many :projects,
    through: :project_libraries, :dependent => :destroy

  def sample_exists?(sample)
    library_entries.exists?(["sample_id = ?", sample.id])
  end


  def add_molecule(molecule, user)

    s = Sample.new
    s.molecule = molecule 
    s.target_amount = "0"
    s.unit = "mg"
    s.save


    add_sample(s, user)

  end

  def add_sample(sample, user)

    le = LibraryEntry.new

    if !sample.molecule.nil? then
      le.molecule_id = sample.molecule.id
    end

    le.sample_id = sample.id
    le.library_id = self.id
    le.save

  end


  def migrate

    # add a sample for each molecule in each project

    # add sample_id to each dataset from each molecule

  end
end
