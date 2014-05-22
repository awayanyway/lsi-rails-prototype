class AttachmentsController < ApplicationController
  
  before_filter :authenticate_user!, except: [:index, :show, :create, :link]

  skip_before_filter :verify_authenticity_token, only: [:create, :link]

  # GET /attachments
  # GET /attachments.json
  def index
    @dataset = Dataset.find(params[:dataset_id])
    @attachments = @dataset.attachments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {:files => @attachments.collect { |a| a.to_jq_upload } }.to_json }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @dataset = Dataset.find(params[:dataset_id])
    @attachment = Attachment.find(params[:id])

    authorize @attachment


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachment }
    end
  end

  def _get_subpathoffile(path)

    elements = path.split("/")

    res = []

    if elements.count > 3 then 

      res = elements[2..-2]

      return res.join("/")+"/"

    end

    return ""
  end

  def serve
    line = "--------------------------\n#{caller(0)[0..1]}\n"
    @dataset = Dataset.find(params[:dataset_id])

    if params[:extension].blank? then
      fn = params[:filename]
    else
      fn = params[:filename]+"."+params[:extension]
    end

    if params[:folder].blank? then
      folder = ""
    else
      folder = params[:folder]+"/"
    end
    filename = fn.split("/").last
    version = nil
    
    line << "got <folder:#{folder}> and <filename:#{filename}> "
    line << "\nserve folder: #{folder}-#{filename}" <<"\n<full name:#{fn}>"
    line << "\n end of \n#{caller(0)[0]}\n--------------------------"
    puts line
    
    @attachment = @dataset.attachments.where(["file = ? and folder = ?", filename, folder]).first

    if @attachment.nil? then 

      

      if !filename.split("_").first.nil? then
        version = filename.split("_").first
        filename = filename.split("_")[1..-1].compact.join("_")

        type = "image/jpeg"
        
      end

      @attachment = @dataset.attachments.where(["file = ? and folder = ?", filename, folder]).first

    end

    authorize @attachment

    localfile = LsiRailsPrototype::Application.config.datasetroot + "datasets/#{@dataset.id}/#{folder}#{[version, filename].compact.join("_")}"

    Rails.logger.info "serving "+localfile
    
    if type.nil? then
      send_file localfile
    else 
      send_file localfile, :type => type, :disposition => :inline
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @dataset = Dataset.find(params[:dataset_id])
    @attachment = @dataset.attachments.build

    authorize @attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @dataset = Dataset.find(params[:dataset_id])
    @attachment = @dataset.attachments.build(params[:attachment])

    authorize @attachment

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to dataset_url(@attachment.dataset_id), notice: 'Attachment was successfully created.' }
        format.json { render :json => {:files => [ @attachment.to_jq_upload ]}.to_json }
      else
        format.html { render action: "new" }
        format.json { render :json => {:files => [ @attachment.to_jq_upload.merge({ :error => "custom_failure" }) ]}.to_json }
      end
    end
  end

  def link
    @dataset = Dataset.find(params[:dataset_id])

    fn = params[:attachment][:filename]
    params[:attachment].delete :filename
    
    @attachment = @dataset.attachments.build(params[:attachment])
    @attachment.file = File.new(fn)

    authorize @attachment

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to dataset_url(@attachment.dataset_id), notice: 'Attachment was successfully created.' }
        format.json { render :json => {:files => [ @attachment.to_jq_upload ]}.to_json }
      else
        format.html { render action: "new" }
        format.json { render :json => {:files => [ @attachment.to_jq_upload.merge({ :error => "custom_failure" }) ]}.to_json }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])

    authorize @attachment

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to  dataset_url(@attachment.dataset_id), notice: 'Attachment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])

    authorize @attachment

    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to  dataset_url(@attachment.dataset_id) }
      format.json { head :no_content }
    end
  end
end
