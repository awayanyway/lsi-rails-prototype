class Attachment < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessible :dataset_id, :file, :folder, :dataset_attributes, :dataset, :attachment_url, :file_attributes, :filecreation, :filechange, :fullfilename
  
  mount_uploader :file, AttachmentUploader

  belongs_to :dataset

  def as_json(options= {})
    super(:methods => [:filename, :filesize])

  end


  def as_mini_json(options= {})
    h = Hash.new
    h[:fullfilename] = read_attribute(:fullfilename)
    h[:filename] = read_attribute(:file)
    h[:filesize] = file.size
    h[:folder] = read_attribute(:folder)
    h
  end

  def filesize

    file.size

  end

  def filename

    filename?

  end

  def filename?
    if read_attribute(:file).nil? then "" else read_attribute(:file) end
  end

  def folder?
    if read_attribute(:folder).nil? then "" else read_attribute(:folder) end
  end

  def to_jq_upload
  {
    "id" => read_attribute(:id),
    "title" => read_attribute(:file),
    "description" => read_attribute(:file),
    "name" => read_attribute(:file),
    "size" => file.size,
    "url" => file.url,
    "relativePath" => read_attribute(:folder),
    "thumbnailUrl" => file.thumb.url,
    "deleteUrl" => dataset_attachment_path(:dataset_id => dataset_id, :id => read_attribute(:id)),
    "deleteType" => "DELETE" 
   }
  end

  after_save :trigger_detect
  def trigger_detect
    dataset.detect_parameters
  end


end
