class DatasetsController < ApplicationController
  
  helper DatasetsHelper
  
  
   
  require 'zip'

  before_filter :authenticate_user!, except: [:show, :filter, :find, :finalize]

  before_action :set_dataset, only: [:show, :edit, :update, :destroy, :assign, :assign_do, :commit, :zip, :plotpoint]

  before_action :set_project

  before_action :set_project_dataset, only: [:show, :edit, :update, :destroy, :assign, :commit, :zip]

  before_action :set_empty_project_dataset, only: [:create, :create_direct, :new, :assign_do]
  

  # GET /datasets
  # GET /datasets.json
  def index
    @project_datasets = ProjectDataset.where(["project_id = ?", @project.id]).paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @datasets }
    end
  end

  def assign

    authorize @project_dataset, :show?

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @molecule }
    end
  end

  def assign_do

    authorize @project_dataset, :assign?

    @project.add_dataset(@dataset, current_user)

    redirect_to molecule_path(@molecule, :project_id => params[:project_id]), notice: "Dataset was assigned to project."
  end   


  def find
    @dataset =  Dataset.where(["uniqueid = ?", params[:uniqueid]]).first

    if @dataset.nil? then 
      @dataset = Dataset.new
      @dataset.uniqueid = params[:uniqueid]

      @dataset.title = URI.unescape(params[:title])
      @dataset.method = URI.unescape(params[:method])

      @dataset.save

      dsg = Datasetgroup.new
      dsg.save
      dsg.datasets << @dataset

      fw = FolderWatcher.where(["serialnumber = ?", params[:serialnumber]]).first

      fw.projects.each do |p|
        @dataset.add_to_project(p.id, nil)
      end

    end
 
    render json: Dataset.where(["uniqueid = ?", params[:uniqueid]]).to_json(:include => {:attachments => {:only => :as_mini_json, :methods => [:as_mini_json]}})
  end

  def finalize
    @dataset =  Dataset.where(["uniqueid = ?", params[:uniqueid]]).first

    fw = FolderWatcher.where(["serialnumber = ?", params[:serialnumber]]).first

    if (!@dataset.nil? && !fw.nil?) then 

      if !(Commit.exists?(["dataset_id = ?", @dataset.id])) then 

        c = Commit.new
        c.dataset_id = @dataset.id
        #c.user_id = current_user.id
        c.save

        measurement = Measurement.new
        measurement.update_attribute(:device_id, fw.device_id)

        cd = DateTime.new(1982, 11, 10)

        if @dataset.recorded_at.nil? then        

          @dataset.attachments.each do |a|

            if a.filechange > cd then

              cd = a.filechange

            end
          end

        else
          cd = @dataset.recorded_at
        end

        measurement.update_attribute(:recorded_at, cd)
        
        measurement.update_attribute(:dataset_id,  @dataset.id)

        measurement.assign_to_user

        measurement.guess_samplename

        measurement.save


        @dataset.zipit

        

      end

    end

    resultjson = {
      :dataset => @dataset,
      :attachments => @dataset.attachments
    }

    render json: resultjson
  end


  # GET /datasets
  # GET /datasets.json
  def filter

    @datasets = Dataset.where(["method = ?", params[:method]])

    respond_to do |format|
      format.html { render :template => "datasets/index" }
      format.json { render json: @datasets }
    end
  end

  def zip

    authorize @project_dataset, :show?

    temp_file = Tempfile.new(@dataset.id.to_s+".zip")

    Zip::OutputStream.open(temp_file.path) { |zos| 

      @dataset.attachments.each do |a|
        zos.put_next_entry(a.folder?+a.filename?)
        zos.print a.file.read
      end
    }

    temp_file.close

    send_data(File.read(temp_file.path), :type => 'application/zip', :filename => "dataset_"+@dataset.webdavpath.to_s+".zip")

  end

  # GET /datasets/1
  # GET /datasets/1.json
  
  
 def munch
     puts "munch it!"
     @dataset =  Dataset.where(["id = ?",params[:dataset_id]]).first
      puts "nice dataset"
     if (file=@dataset.jdx_file)
       puts "monic says U r dumb!"
        @kumara=Rails.cache.fetch("#{file}", :expires_in => 5.minutes){ 
        puts " spoon !  " 
        opt=":file "+file.to_s+" :tab all :process header spec param data point raw first_page " 
        dx_data=Kai.new(opt).flotr2_data 
       if dx_data.is_a?(Switchies::Ropere) 
          puts "\nhello Kumara! \n"
          kumara=dx_data.to_kumara
       else  
         nil
       end  
      }
      else puts "spacehead!"
     end
     kumara= @kumara #||Rails.cache.read("kumara")
     puts kumara.inspect.slice(0..100)
      block ||= (params[:block] && params[:block].to_i) || 0
      page  ||= (params[:page]  && params[:page].to_i)  || 0
      limit ||= (params[:limit] && params[:limit].to_i) || 2048
     if kumara.is_a?(Switchies::Kumara)
     puts "I can't grab your ghost chips!"
     else
     kumara=Switchies::Kumara.blank 
     end
    
     if params[:r0] && params[:r1]
        r0=params[:r0].to_f
        r1=params[:r1].to_f  
        k= (kumara.xy && kumara.xy[block] && kumara.xy[block][page]) || [[0,0],[0,0]] 
        puts "inspect xy: #{puts k.inspect.slice(0..100)}\n"
        step=( k[-1][0] - k[0][0] )/(k.size - 1)
        r0= ( (r0 - k[0][0]) / step).to_i
        r1= ( (r1 - k[0][0]) / step).to_i 
        r0,r1=r1,r0  if r0 > r1
        r0 -= 1 if r0>0
        r1 += 1  
     else r0,r1=0,-1 
     end
     r     ||= params[:r]    || r0..r1
    
     puts "munch it with <r0..r1:#{r0}..#{r1}> <r:#{r}> <block:#{block}> <page:#{page}> <limit:#{limit}>"
      @plotdx=kumara.chip_it(r,block,page,limit)
     #puts [k.trim_point(r,limit)].to_s.slice(0..100)
     
     
     render :json => (k && [k.trim_point(r,limit)]) || nil
     #render :json => @plotdx || nil
   
end
 
  
  def plotpoint
     @dataset =  Dataset.where(["id = ?",params[:dataset_id]]).first
      if Kai.test_file(@dataset.jdx_file)
       file=@dataset.jdx_file 
        puts "nice dataset @<#{file}>"
        @kumara=Rails.cache.fetch("#{file}", :expires_in => 5.minutes){ 
                puts " spoon !  " 
                opt=":file "+file.to_s+" :tab all :process header spec param data point raw first_page " 
                dx_data=Kai.new(opt).flotr2_data 
               if dx_data.is_a?(Switchies::Ropere) 
                  puts "\nhello Kumara! \n"
                  kumara=dx_data.to_kumara
               else  
                  puts "\nwanna chips? Bro'  \n"
                 nil
               end  
          }
      end
       
      if !@kumara
        @kumara=Switchies::Kumara.blank
      end         
       @plotdx=@kumara.chip_it   
    respond_to do |format|
      format.html { render partial: 'plotting' , locals: {dataset: @dataset} }
      #format.html { render action: "plot" }
      #format.json { render json: @dataset }
    end

  end
    

  def show
    authorize @project_dataset


    @changerights = false

    if !current_user.nil? && current_user.datasetowner_of?(@dataset) then @changerights = true end

    if Commit.exists?(["dataset_id = ?", @dataset.id]) then @changerights = false end

    @attachment = Attachment.new(:dataset => @dataset)
    ####
    puts "~~~~~~~~~~~~~\nGeorge is pretty drunk"
    @kumara=Switchies::Kumara.blank
    @plotdx=@kumara.chip_it
    puts @plotdx.inspect.slice(0..100)
    puts "~~~~~~~~~~~~~~~~"
    
    respond_to do |format|
      if !(Commit.exists?(["dataset_id = ?", @dataset.id])) then flash.now[:notice] = 'Dataset is in editing mode. Commit your changes after you\'re done.' end

      if (Commit.exists?(["dataset_id = ?", @dataset.id])) then flash.now[:notice] = 'Dataset is read-only. To edit, fork it first.' end

      if true == false then flash.now[:warning] = "This is not the last version of the dataset, check the version history." end

      format.html { render action: "show" }
      format.json { render json: @dataset }
    end
  end



  # GET /datasets/new
  # GET /datasets/new.json
  def new
    @dataset = Dataset.new

    authorize project_dataset, :new?

    @dataset.molecule_id = params[:molecule_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dataset }
    end
  end

  # GET /datasets/1/edit
  def edit
    authorize @project_dataset

    @reaction_id = params[:reaction_id]
  end


  def commit
    authorize @project_dataset, :edit?

    c = Commit.new
    c.dataset_id = @dataset.id
    c.user_id = current_user.id

    respond_to do |format|
      if c.save
        format.html { redirect_to dataset_path(@dataset, :project_id => @project.id), notice: 'Dataset was successfully committed.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end

  end

  def create_direct
    @dataset = Dataset.new

    authorize @project_dataset, :create?

    @dataset.molecule_id = params[:molecule_id]

    @dataset.sample_id = params[:sample_id]

    puts "ADDED TO SAMPLE " + @dataset.sample_id.to_s

    @dataset.title = "no title"
    @dataset.method = "no method"
    @dataset.description = ""
    @dataset.details = ""

    if !@dataset.molecule.nil? then 

      assign_version_to_dataset @dataset, @dataset.molecule

    end

    assign_method_rank @dataset

    respond_to do |format|
      if @dataset.save

          if !(params[:reaction_id].nil?) then 

        dm = ReactionDataset.new
          dm.reaction_id = params[:reaction_id]
          dm.dataset_id = @dataset.id
          dm.save
        end

        if params[:project_id].nil? then

          @project = current_user.rootproject

        else

          @project = Project.find(params[:project_id])

        end

        @project.add_dataset(@dataset, current_user)

        Sample.find(params[:sample_id]).add_dataset(@dataset, current_user)


        dsg = Datasetgroup.new
        dsg.save
        dsg.datasets << @dataset

        format.html { redirect_to dataset_path(@dataset.id, :reaction_id => params[:reaction_id], :project_id => @project.id , notice: 'Dataset was successfully created.') }
        format.json { render json: @dataset, status: :created, location: @dataset }
      else
        format.html { render action: "new" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end

  end

  # POST /datasets
  # POST /datasets.json
  def create
    @dataset = Dataset.new(params[:dataset])

    authorize @project_dataset

    if !@dataset.molecule.nil? then 

      assign_version_to_dataset @dataset, @dataset.molecule

    end

    assign_method_rank @dataset

    respond_to do |format|
      if @dataset.save

        @dataset.add_to_project(current_user.rootproject_id, current_user)

        if !@dataset.molecule.nil? then 


          @dataset.molecule.projects.each do |p|

            if current_user.projects.exists?(p) then
              @dataset.add_to_project(p.id, current_user)
            end
          end

        end

        dsg = Datasetgroup.new
        dsg.save
        dsg.datasets << @dataset

        format.html { redirect_to dataset_path(@dataset, :project_id => @project.id), notice: 'Dataset was successfully created.' }
        format.json { render json: @dataset, status: :created, location: @dataset }
      else
        format.html { render action: "new" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_between_clouds(obj, src, dest)
    tmp = File.new("/tmp/tmp", "wb")
    begin
      filename = src.file.url
      File.open(tmp, "wb") do |file|
        file << open(filename).read
      end
      t = File.new(tmp)
      sf = CarrierWave::SanitizedFile.new(t)
      dest.file.store(sf)
    ensure
      File.delete(tmp)
    end
  end

  # POST /datasets
  # POST /datasets.json
  def fork

    # TODO

    @olddataset = Dataset.find(params[:id])

    authorize @olddataset, :show?

    @dataset = @olddataset.transfer_to_sample(@olddataset.sample, current_user)

    @olddataset.transfer_attachments_to_dataset(@dataset)

    dsg = @olddataset.datasetgroups.first
    dsg.datasets << @dataset

#    if !@dataset.molecule.nil? then 

 #     assign_version_to_dataset @dataset, @dataset.molecule

  #  end

    respond_to do |format|

        format.html { redirect_to dataset_path(@dataset, :project_id => @project.id), notice: 'Dataset was successfully forked.' }
        format.json { render json: @dataset, status: :created, location: @dataset }

    end
  end

  # PUT /datasets/1
  # PUT /datasets/1.json
  def update
    authorize @project_dataset

    assign_method_rank @dataset

  

    respond_to do |format|
      if @dataset.update_attributes(params[:dataset])
        format.html { redirect_to dataset_path(@dataset.id, :reaction_id => params[:reaction_id], :project_id => @project.id, notice: 'Dataset was successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    authorize @project_dataset

    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to datasets_path(:project_id => @project.id) }
      format.json { head :no_content }
    end
  end


  private

    def assign_version_to_dataset (dataset, molecule)

      similarmethoddatasets = molecule.datasets.where(["method = ?", dataset.method])
      dataset.version = (similarmethoddatasets.length).to_s

    end

    def assign_method_rank (dataset)

      m = dataset.method

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

      dataset.method_rank = r

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    def set_project
      if current_user.nil? then 
        @project = Project.where(["title = ?", "chemotion"]).first
      else
        if params[:project_id].nil? || params[:project_id].empty? then
          if Project.where(["title = ?", "chemotion"]).length > 0 then
            @project = Project.where(["title = ?", "chemotion"]).first
          else
            @project = current_user.rootproject
          end
        else
          @project = Project.find(params[:project_id])
        end
      end
    end


    def set_empty_project_dataset
      @project_dataset = ProjectDataset.new(:project_id => @project.id)
    end

    def set_project_dataset
      @project_dataset = ProjectDataset.where(["project_id = ? AND dataset_id = ?", @project.id, @dataset.id]).first
    end

end
