class Sample < ActiveRecord::Base
  attr_accessible :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, :molecule_attributes, :compound_id, :originsample_id, :name

  # has_many :task_samples
  # has_many :tasks, :through => :task_samples

  has_many :molecule_samples

  belongs_to :molecule, :autosave => true, inverse_of: :samples

  belongs_to :originsample, :class_name => Sample, :foreign_key => :originsample_id

  accepts_nested_attributes_for :molecule 


  has_many :sample_reactions
  has_many :reactions,
  	:through => :sample_reactions

  has_many :datasets, :dependent => :destroy

  has_many :library_entries, :dependent => :destroy

  before_destroy :checkout_everywhere

  before_destroy :cleanup_localprojects

  def checkout_everywhere

    Location.all.each do |l|

      if l.sample_id == self.id then l.update_attribute(:sample_id, nil) end

    end

  end
  
  def cleanup_localprojects

    self.projects.each do |p|

      self.remove_from_project(p)
    end

  end

  def cleanup_projects_database(project)

    p = Project.find(project_id)

    p.add_sample(self)

    if Project.exists?(Project.find(project_id).parent_id) then parent = p.parent end

    loop do

      if !parent.nil? then

        parent.add_sample(self)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end



  class CrossRef
    include HTTParty
    debug_output $stderr
    base_uri 'http://search.crossref.org'


    def get_record(doi)
      # options = { :query => {:doi => doi, :url => url}, 
      #             :basic_auth => @auth, :headers => {'Content-Type' => 'text/plain'} }

      options = { :timeout => 3,  :headers => {'Content-Type' => 'text/json'}  }

      self.class.get('http://search.crossref.org/dois?q='+doi, options)
    end

  end

  def add_literature(doi)

    res = CrossRef

    cr = CrossRef.new

    begin
          jsonresult = cr.get_record(doi)
    rescue
          jsonresult = nil
    end

    if !jsonresult.nil? && !jsonresult[0].nil? then

      puts jsonresult[0]

      c = Citation.new
      c.title = jsonresult[0]["title"]
      c.fullcitation = jsonresult[0]["fullCitation"]
      c.doi = doi
      c.save

      citations << c

    end

  end

  has_many :sample_citations
  has_many :citations,
    :through => :sample_citations

  def add_dataset(dataset, user)

    self.datasets << dataset

    self.projects.each do |p|
      p.add_dataset(dataset, user)
    end

  end

  def transfer_to_project(project, user)

    newsample = self.dup

    newsample.ancestor_id = self.id
    
    newsample.save

    project.add_sample(newsample, user)

    newsample

  end

  def name

    if read_attribute(:name).nil? then

      "S"+self.id.to_s

    else read_attribute(:name)


    end

  end

  def breadcrumbs

    s = self

    res = []

    while !s.originsample.nil? do

      s = s.originsample

      res << s.name
     
    end

    return res.join("/")

  end

  def longname

    s = self

    res = s.name

    if !breadcrumbs.empty? then res = breadcrumbs + "/"+res end

    return res

  end

  def weight

    self.actual_amount - self.tare_amount

  end

  def role

      if self.is_virtual && self.is_startingmaterial then return "educt" end
     
      if self.is_virtual && !self.is_startingmaterial then return "reactant" end

      if !self.is_virtual && !self.is_startingmaterial then return "product" end
       
  end

  def molecule_attributes=(molecule_attr)

    if (molecule_attr['id'] != nil && molecule_attr[:id] != '') then
      if _molecule = Molecule.find(molecule_attr['id']) then

        self.molecule = _molecule
        return true
      end
    end

    self.molecule = Molecule.new (molecule_attr)

  end

  def has_analytics?(reaction, methodpart)

    datasets = self.datasets.where(["sample_id = ? AND method ilike ?", self.id, "%"+methodpart+"%"])

    return (datasets.length > 0)

  end

  def has_unconfirmed_analytics?(current_user, reaction, methodpart)

    ms = Measurement.where(["user_id = ? and reaction_id = ? and molecule_id = ? and confirmed = ?", current_user.id, reaction.id, self.molecule.id, false])

    ms.each do |m|
      if m.dataset.method.include?(methodpart) then return true end

    end

    return false
  end

   # project association

  has_many :project_samples
  has_many :projects,
  through: :project_samples, :dependent => :destroy

  def add_to_project_recursive (project_id, user)

    p = Project.find(project_id)
    p.add_sample(self, user)

    if Project.exists?(Project.find(project_id).parent_id) then parent = p.parent end

    loop do

      if !parent.nil? then

        parent.add_sample(self, user)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end

  def remove_from_library(library)

    ProjectLibrary.where(["library_id = ?", library.id]).each do |pl|

      pl.library.library_entries.where(["sample_id = ?", self.id]).destroy_all

      pl.project.remove_sample_only(self)
    end

  end

  def remove_from_project(project)

    project.remove_sample_only(self)

  end

  def remove_from_project_database(project)

    self.remove_from_project(project)

    if Project.exists?(project.parent_id) then parent = project.parent end

    loop do

      if !parent.nil? then

        self.remove_from_project(parent)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

    self.remove_from_project_children(project)

  end

  def remove_from_project_children(project)

    self.remove_from_project(project)

    project.children.each do |child|

      self.remove_from_project_children(child)

    end

  end


  def as_json(options={})
    super(:include => [:molecule, :datasets => {:include => [:attachments => {:methods => [:filename, :filesize]}]}])
    
  end
 
end
