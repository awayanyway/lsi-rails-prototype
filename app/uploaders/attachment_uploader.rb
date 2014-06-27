# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.localserver? or Rails.env.development? then 
    storage :file
  else
     storage :fog
  end
  
  # Choose whether to process jdx file or not
  #Rails.configuration.jdx_support.cw_thumbnail = true

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if Rails.env.localserver? or Rails.env.development? then 
       LsiRailsPrototype::Application.config.datasetroot + "datasets/#{model.dataset_id}/#{model.folder}"
     else
       "datasets/#{model.dataset_id}/#{model.folder}"
     end
    
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    #  "/attachments/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  def url(options={})
    
    
     if Rails.env.localserver? or Rails.env.development? then 
       "/datasets/#{model.dataset_id}/#{model.folder}#{[version_name, File.basename(model.file.path.to_s)].compact.join('_')}"
     else
       super(options)
     end
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
 
  # Create different versions of your uploaded files:
     
     h1={:if => :image?} 
     h2={:if => :jdx?,  :from_version => :dummy}
     h3={:if => :image?,:from_version => :dummy}
     
     
     version(:dummy, h1){ process :dx4lsi, :if => :jdx?}
    
     
     version(:jdx,h2)
     #process :resize_first_page
     version(:thumb,h3){
     
     process :dx_2_ps, :if => :jdx?
     
     process :convert => :jpg
# 
     process :resize_to_fit => [450, 300]
# 
     process :set_content_type
     }
  
     

 
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.


  protected

  def resize_first_page
    manipulate! do |pdff|
      first_page = CarrierWave::MiniMagick::ImageList.new("#{current_path}[0]").first
      thumb = first_page.resize_to_fill!(450, 300)
      thumb
    end
  end

  
  def dx4lsi
    Jcampdx.load_jdx(":file #{current_path} :process  point raw :output lsi :output_file #{current_path} ")
  end
  
  def dx_2_ps
     Jcampdx.load_yaml_2_ps(":file #{current_path} ")
  end

  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/jpeg")
  end

  def image?(new_file)

    if Rails.configuration.jdx_support.cw_thumbnail then
       extensions = %w(jpg jpeg gif png pdf ps dx jdx)
    else
      extensions = %w(jpg jpeg gif png pdf ps)
    end

    extension = File.extname(new_file.path.to_s).downcase
    extension = extension[1..-1] if extension[0,1] == '.'

    extensions.include?(extension)

  end

  def jdx?(new_file)
   if Rails.configuration.jdx_support.cw_thumbnail then
     extensions = %w(jdx dx)
     extension = File.extname(new_file.path.to_s).downcase
     extension = extension[1..-1] if extension[0,1] == '.'

     extensions.include?(extension)
   else
     false
   end
  end

end
