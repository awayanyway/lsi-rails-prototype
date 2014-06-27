class Project < ActiveRecord::Base
  attr_accessible :parent_id, :title, :rootlibrary_id

  has_many :project_memberships, :dependent => :destroy

  def title

    if self.read_attribute(:title).nil? then 
      self.owner.firstname.to_s+"'s Project"
    else self.read_attribute(:title) end

  end

  def rootlibrary
    Library.find(self.rootlibrary_id)
  end

  def members
  	User.joins(:project_memberships).where(["role_id = ? and project_id = ?", 88, id])
  end

  def owner
  	User.joins(:project_memberships).where(["role_id = ? and project_id = ?", 99, id]).first
  end

  def role_str(user)

    if !user.nil? then

    roles = ProjectMembership.where(["user_id = ? and project_id = ?", user.id, id])

    roles.each do |r|

      if r.role_id == 99 then return "R+W" end

      if r.role_id == 95 then return "R+P" end

      if r.role_id == 88 then return "R" end

    end

    else

      return "X"

    end

  end

  def create_rootlibrary(user)
    rp = Library.create!
    rp.save

    ProjectLibrary.new(:project_id => self.id, :library_id => rp.id, :user_id => user.id).save

    update_attributes(:rootlibrary_id => rp.id)

  end

  def superparent

    if Project.exists?(self.parent_id) then parent = self.parent end

    loop do

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

    if parent.nil? then parent = self end

    parent

  end

  def parent
    Project.find(parent_id)
  end

  def parent_exists?
    Project.exists?(parent_id)
  end

  def children

    Project.where(["parent_id = ?", self.id])

  end

  # associations

  has_many :project_molecules
  has_many :molecules,
    through: :project_molecules, :dependent => :destroy

  has_many :project_datasets
  has_many :datasets,
    through: :project_datasets, :dependent => :destroy

  has_many :project_beaglebones
  has_many :beaglebones,
    through: :project_beaglebones, :dependent => :destroy

  has_many :project_folder_watchers
  has_many :folder_watchers,
    through: :project_folder_watchers, :dependent => :destroy

    has_many :project_vncrelays
  has_many :vncrelays,
    through: :project_vncrelays, :dependent => :destroy


  has_many :project_devices
  has_many :devices,
    through: :project_devices, :dependent => :destroy

  has_many :project_reactions
  has_many :reactions,
    through: :project_reactions, :dependent => :destroy

  has_many :project_samples
  has_many :samples,
    through: :project_samples, :dependent => :destroy

  has_many :project_libraries
  has_many :libraries,
    through: :project_libraries, :dependent => :destroy

  def add_library(library, user)

    pm = ProjectLibrary.new
    pm.library_id = self.id
    pm.project_id = project_id
    pm.save

  end

  def add_reaction(reaction, user)

    ProjectReaction.new(:project_id => self.id, :reaction_id => reaction.id, :user_id => user.id).save unless reactions.exists?(reaction)

    reaction.samples.each do |s|

      add_sample_only(s, user)

    end

    parent.add_reaction(reaction, user) unless !parent_exists?

  end

  def remove_reaction(reaction)
    remove_reaction_only(reaction)
    
    parent.remove_reaction(reaction) unless !parent_exists?
  end

  def remove_reaction_only(reaction)

    reactions.delete(reaction) if reactions.exists?(reaction)

    self.children.each do |child|

      child.remove_reaction_only(reaction)

    end

    reaction.samples.each do |s|
      remove_sample_only(s)
    end

  end


  def add_molecule(molecule, user)

    ProjectMolecule.new(:project_id => self.id, :molecule_id => molecule.id, :user_id => user.id).save unless molecules.exists?(molecule)
    
    rootlibrary.add_molecule(molecule, user)

    parent.add_molecule(molecule, user) unless !parent_exists?

  end

  def add_sample_only(sample, user)

    ProjectSample.new(:project_id => self.id, :sample_id => sample.id, :user_id => user.id).save unless samples.exists?(sample)

    if !sample.molecule.nil? then

    ProjectMolecule.new(:project_id => self.id, :molecule_id => sample.molecule.id, :user_id => user.id).save unless molecules.exists?(sample.molecule)

    end

    rootlibrary.add_sample(sample, user) unless rootlibrary.sample_exists?(sample)

    sample.datasets.each do |ds|
      add_dataset_only(ds, user)
    end

  end

  def add_sample(sample, user)

    add_sample_only(sample, user)
    
    parent.add_sample(sample, user) unless !parent_exists?
  end

  def add_dataset(dataset, user)

    add_dataset_only(dataset, user)

    parent.add_dataset(dataset, user) unless !parent_exists?

  end

  def add_dataset_only(dataset, user)

    ProjectDataset.new(:project_id => self.id, :dataset_id => dataset.id, :user_id => user.id).save unless datasets.exists?(dataset)

  end

  def remove_dataset_only(dataset)

    datasets.delete(dataset) if datasets.exists?(dataset)

  end


  def remove_sample(sample)
    remove_sample_only(sample)
    
    parent.remove_sample(sample) unless !parent_exists?
  end

  # überarbeiten:

  def remove_sample_only(sample)

    samples.delete(sample) if samples.exists?(sample)

    more_samples_with_same_molecule = false

    self.samples.each do |s|

      if s.molecule == sample.molecule then more_samples_with_same_molecule = true end
    end

    molecules.delete(sample.molecule) if !more_samples_with_same_molecule


    self.rootlibrary.library_entries.where(["sample_id = ?", sample.id]).destroy_all

    sample.datasets.each do |ds|
      remove_dataset_only(ds)
    end

  end

end
