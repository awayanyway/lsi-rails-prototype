class Dataset < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper

  attr_accessible :attachments, :molecule_id, :title, :description, :method, :details, :preview_id, :recorded_at, :dataset_id, :sample_id, :method_rank
  attr_accessible :jdx_file

  has_many :attachments, :dependent => :destroy

  belongs_to :molecule
  belongs_to :sample

  has_one :measurement, :dependent => :destroy

  has_many :datasetgroup_datasets
  has_many :datasetgroups,
    through: :datasetgroup_datasets, :dependent => :destroy

  has_many :reaction_datasets
  has_many :reactions,
    through: :reaction_datasets

  has_many :commits, :dependent => :destroy

  # acts_as_list scope: :datasetgroup_dataset
  def transfer_to_sample(sample, user)

    newdataset = self.dup

    newdataset.save

    sample.add_dataset(newdataset, user)

    return newdataset

  end

  def transfer_attachments_to_dataset(dataset)
    self.attachments.each do |a|



          newattachment = Attachment.new(:dataset => dataset)

          newattachment.folder = a.folder

          if Rails.env.localserver? or Rails.env.development? then 

            old_path = LsiRailsPrototype::Application.config.datasetroot + "datasets/#{self.id}/#{a.folder}#{a.filename}"

            new_path = LsiRailsPrototype::Application.config.datasetroot + "datasets/#{dataset.id}/#{a.folder}#{a.filename}"


        FileUtils.mkdir_p(File.dirname(new_path))
        FileUtils.cp(old_path, new_path)

            newattachment.file = File.new(new_path)

          else
            newattachment.remote_file_url = a.file_url
          end


      newattachment.save

      dataset.add_attachment(newattachment)

    end

  end

  def add_attachment(attachment)

    self.attachments << attachment

  end

  def zipit

    # create zip file

    puts ziplocation?

  end

  def ziplocation?

    if Rails.env.localserver? or Rails.env.development? then
      LsiRailsPrototype::Application.config.datasetroot + "datasets/#{self.id}.zip"
    else
      "datasets/#{self.id}.zip"
    end
  end

  def oai_dc_identifier
    "http://dx.doi.org/"+doi_identifier
  end

  def doi_identifier

    if !sample.nil? then
  	if !sample.molecule.nil? then 


      v = ""
      if (!version.blank? && !(version == "0")) then v = "."+version end


  		if !ENV['DOI_PREFIX'].nil? then
  			ENV['DOI_PREFIX']+"/"+sample.molecule.inchikey+"/"+method+v
  		end
  	end

    end

  end

  def webdavpath

    beautify(self.id.to_s+"-"+self.method + "-" +self.title)

  end

  def beautify(path)
    newpath = path.gsub("/", "_")
    newpath = newpath.gsub(" ", "_")
    newpath
  end

  def allfolders?

    res = []

    self.attachments.each do |at|

      f = "/"+at.folder?[0..-2]

      if !res.include?(f) then

      res << f
      end

      f.split("/").each do |nf|

        if !res.include?("/"+nf) then

          res << "/"+nf
        end
      end
    end

    return res

  end

  def uniquefolders?

    res = []

    self.attachments.each do |at|

      f = at.folder?[0..-1]

      if !res.include?(f) then

        if !f.nil? && f != "" then

        res << f

        end
      end

    end

    return res

  end

  def preview_url
    if !preview_id.nil? then
      at = Attachment.find(preview_id).first
    else
      at = attachments.where(["file = ? or file = ? or file = ? or file = ?", "preview.jpg", "preview.jpeg", "preview.JPG", "preview.JPEG"]).first

      if (at.nil?) then
        # select the best fit

        at = attachments.where(["file ilike ? or file ilike ? or file ilike ? or file ilike ? or file ilike ? or file ilike ? or file ilike ?", "%jpeg", "%jpg", "%pdf", "%gif", "%ps", "%dx", "%jdx"]).first
      end
    end

    if (!at.nil?) then
    at.file.thumb.url
    else
      "/nopreview.jpg"
    end

  end

  has_many :project_datasets
  has_many :projects,
    through: :project_datasets, :dependent => :destroy

  def add_to_project_recursive (project_id, user)

    add_to_project(project_id, user)

    if Project.exists?(Project.find(project_id).parent_id) then parent = Project.find(Project.find(project_id).parent_id) end

    loop do

      if !parent.nil? then

        add_to_project(parent.id, user)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end

  def add_to_project (project_id, user)

    pm = ProjectDataset.new
    pm.dataset_id = self.id
    pm.project_id = project_id

    if !user.nil? then
      pm.user_id = user.id
    end
    
    pm.save

  end

  def assign_method_rank

    m = self.method

    r = 0

    if !m.nil? then
      if m.start_with?('Rf') then r = 10 end
      if m.start_with?('NMR/1H') then r = 20 end
      if m.start_with?('NMR/13C') then r = 30 end
      if m.start_with?('IR') then r = 40 end
      if m.start_with?('Mass') then r = 50 end
      if m.start_with?('GCMS') then r = 60 end
      if m.start_with?('Raman') then r = 65 end
      if m.start_with?('UV') then r = 70 end
      if m.start_with?('TLC') then r = 75 end
      if m.start_with?('Xray') then r = 80 end
    end

    self.method_rank = r

  end

  # analysis methods

  def detect_parameters
    self.update_attribute(:jdx_file,nil)
    attachments.each do |a|
     
     a.file.version_exists?(:dummy) && a.file.dummy.remove!
    #detect jdx
   
      
      if Rails.configuration.jdx_support.detect_jdx  && a.read_attribute(:file) =~ /j?dx\z/i && (y_file = inspect_uploader(a)) then
        
        jdx_data = Kai.new(":file yaml|#{y_file}").result 
        m = jdx_data.detect(:method)
        title = jdx_data.detect(:title)
        title = "" 
        self.update_attribute(:title, title) if title
        self.update_attribute(:method, m)    if m
        self.update_attribute(:jdx_file, "yaml|"+y_file)

      end

      if a.folder == "pdata/1/" && a.read_attribute(:file) == "proc" then

        self.update_attribute(:recorded_at, a.filechange)

        scanfreq = "0"
        
        a.file.read.each_line do |line|
          key, value = line.split("=")

          if !(key.nil?) && !(value.nil?) then

            if "\#\#\$TI".start_with?(key.to_s) then
              t = value.to_s.strip.delete("<>")
              if !(t.blank?) then
                self.update_attribute(:title, t)
              end
            end

            if "\#\#\$SF".start_with?(key.to_s) then
              scanfreq = number_with_precision(value.to_s.strip.delete("<>").to_f, :precision => 0)
            end

            if "\#\#\$SREGLST".start_with?(key.to_s) then
              t = value.to_s.strip.delete("<>")

              nucleus, solvent = t.split(".")

              m = "NMR/" + nucleus + "/" + solvent + "/" + scanfreq
              self.update_attribute(:method, m)
            end

          end
        end
      end

      if a.folder == "pdata/1/" && a.read_attribute(:file) == "title" then

        self.update_attribute(:recorded_at, a.filechange)

        content = a.file.read
        t = content.squish
        puts t
        if !(t.blank?) then
          self.update_attribute(:title, t)
        end

      end

      ## detect Agilent GCMS

      if a.folder == "" && a.read_attribute(:file) == "runstart.txt" then

        self.update_attribute(:recorded_at, a.filechange)

        a.file.read.each_line do |line|

          if (line.squish.start_with?("Sample Name")) then
            k, v = line.split("=")

            t = v.squish

            if !(t.blank?) then
              if !(t.start_with?("Blank")) then
                self.update_attribute(:title, t)
              end
            end
          end

          if (line.squish.start_with?("Methfile")) then
            k, v = line.split("=")

            t = v.squish
            t = t[0..-3]

            if !(t.blank?) then
              if !(t.start_with?("Blank")) then
                self.update_attribute(:method, "GCMS/"+t)
              end
            end
          end

        end

      end

      ## detect Agilent HPLC

      if a.folder == "" && (a.read_attribute(:file).downcase == "data.ms") then

        self.update_attribute(:recorded_at, a.filechange)

      end

      if a.folder == "" && (a.read_attribute(:file).downcase == "report.txt") then

        self.update_attribute(:recorded_at, a.filechange)

        a.file.read.each_line do |line|

          if (line.squish.start_with?("Sample Name")) then
            k, v = line.split(":")

            t = v.squish

            if !(t.blank?) then
              if !(t.start_with?("Blank")) then
                self.update_attribute(:title, t)
              end
            end
          end

        end
      end

    end

  end

  def as_json(options={})
    super(:include => [:attachments => {:methods => [:filename, :filesize]}])
  end

  
  
  def inspect_uploader(a=nil)
    return if a.nil? || !a.file.version_exists?(:jdx)
   
     u=a.file.jdx
     ### uploader methods to check:  
        met=[]
        #met=[:inspect, :class, :file , :url, :default_url,:cached?, :path,:current_path, :cache_name, :cache_dir]      
        ### check  before caching
        line  = "\n"+"@"*10+"BEFORE caching"+"<path = cache_dir + cache_name> is "+((u.path.to_s == File.join(u.cache_dir.to_s,u.cache_name.to_s) && "TRUE") || "FALSE")
        met.each{|meth| line+="\n@@@#{meth}"+" "*(16-meth.size)+":"+u.send(meth).inspect}
        ### cache uploader if not cached
        line << "\n" << "@"*10 << ((u.cached? &&  "attachement already cached") || (u.cache! &&  "attachment now cached") )
        ###check  after caching
        line += "\n"+"@"*10+" AFTER caching"+"<path = cache_dir + cache_name> is "+((u.path.to_s == File.join(u.cache_dir.to_s,u.cache_name.to_s) && "TRUE" )|| "FALSE")
        met.each{|meth| line+="\n@@@#{meth}"+" "*(16-meth.size)+":"+u.send(meth).inspect}
        puts line
        ###########################
        ret = (u.current_path && u.current_path.to_s) || nil
        ret
 end



  def collect_datapoints

    tempfile = Rails.root.join('tmp').join("datapoints_"+self.id.to_s+".list")

    newattachment = Attachment.new(:dataset => self)

    newattachment.folder = ""

    if Rails.env.localserver? or Rails.env.development? then 

      old_path = tempfile

      new_path = LsiRailsPrototype::Application.config.datasetroot + "datasets/#{self.id}/recording.txt"


      FileUtils.mkdir_p(File.dirname(new_path))
      FileUtils.cp(old_path, new_path)

      newattachment.file = File.new(new_path)

    else
      newattachment.file = File.new(tempfile)
    end      

    newattachment.save

    self.add_attachment(newattachment)

    # add_to_project(measurement.user.rootproject_id, measurement.user)

  end

  def add_datapoint(model)

    tempfile = Rails.root.join('tmp').join("datapoints_"+self.id.to_s+".list")

    File.open(tempfile, "a+") do |f|
      f.write (model)
    end

  end


end
