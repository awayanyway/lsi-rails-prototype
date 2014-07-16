class SamplesController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]

  before_action :set_sample, only: [:show, :edit, :update, :destroy, :assign, :assign_do, :split, :transfer, :addliterature, :zip, :clone_to_library, :move_to_library]

  before_action :set_project

  before_action :set_project_sample, only: [:destroy, :show, :edit, :update, :destroy, :assign, :split, :transfer, :addliterature, :zip, :clone_to_library, :move_to_library]

  before_action :set_empty_project_sample, only: [:createdirect, :create, :new, :assign_do]


  def addliterature

    authorize @project_sample, :edit?

    if params[:doi].nil? then 

          render 'samples/addliterature', :id => @sample.id

    else

      @sample.add_literature(params[:doi])

      redirect_to sample_path(@sample, :project_id => params[:project_id]), notice: "Literature was added."

    end


  end

  def update

    authorize @project_sample, :edit?

    respond_to do |format|
      if @sample.update_attributes(params[:sample])
        format.html { redirect_to @sample, notice: 'Sample was successfully updated.' }
        format.json { respond_with_bip(@sample) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@sample) }
      end
    end

  end

  def assign

    authorize @project_sample, :show?

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @sample }
    end
  end

  def assign_do
    authorize @project_sample, :assign?


    if !params[:remove].nil? then

      @project.remove_sample_only(@sample)

      redirect_to samples_path(:project_id => params[:project_id]), notice: "Sample and corresponding datasets were removed from project."

    else

      @project.add_sample(@sample, current_user)

      redirect_to sample_path(@sample, :project_id => params[:project_id]), notice: "Sample and corresponding datasets were assigned to project."

    end

    
  end   

  def createfrommolecule

    @molecule = Molecule.find(params[:molecule_id])
    @project = Project.find(params[:project_id])



  end

  def transfer

    targetproject = nil

    newsample = @sample.transfer_to_project(targetproject, current_user)

    @sample.datasets.each do |ds|

      newdataset = ds.transfer_to_sample(newsample, current_user)
      ds.transfer_attachments_to_dataset(newdataset)

    end


  end

  def split

    s = Sample.new
    s.molecule = @sample.molecule
    s.target_amount = "0"
    s.unit = "mg"
    s.originsample_id = @sample.id
    s.save

    @sample.molecule.samples << s

    @sample.datasets.each do |ds|
      s.datasets << ds
    end

    @project.add_sample(s, current_user)

    redirect_to sample_path(s, :project_id => params[:project_id]), notice: "Sample was splitted."
  end

  def index

    if Library.exists?(params[:library_id]) then

      @library = Library.find(params[:library_id])

    else

      @library = @project.rootlibrary

    end

    @project_library = ProjectLibrary.where(["library_id = ?",  @library.id]).first

    @project_library_entries = @project_library.library.library_entries.paginate(:page => params[:page])

    render 'libraries/show', :id => @library.id

  end

  def move_to_library

    if Library.exists?(params[:library_id]) then

      @library = Library.find(params[:library_id])

    else

      @library = @project.rootlibrary

    end

    targetlibrary = Library.find(params[:targetlibrary_id])


    le = LibraryEntry.where(["library_id = ? and sample_id = ?", @library.id, @sample.id]).first

    if !le.nil? then le.destroy end

    targetlibrary.add_sample(@sample, current_user) unless targetlibrary.sample_exists?(@sample)


    redirect_to samples_path(:project_id => @project.id, :library_id => targetlibrary.id)

  end

  def clone_to_library

    if Library.exists?(params[:library_id]) then

      @library = Library.find(params[:library_id])

    else

      @library = @project.rootlibrary

    end

    targetlibrary = Library.find(params[:targetlibrary_id])

    newsample = @sample.transfer_to_project(@project, current_user)

    targetlibrary.add_sample(newsample, current_user) unless targetlibrary.sample_exists?(newsample)


    redirect_to samples_path(:project_id => @project.id, :library_id => targetlibrary.id)

  end

  def clone_library

    if Library.exists?(params[:library_id]) then

      @library = Library.find(params[:library_id])

    else

      @library = @project.rootlibrary

    end

    @project_library = ProjectLibrary.where(["library_id = ?",  @library.id]).first

    
    l = Library.create!
    l.title = "Copy"
    l.save


    @library.library_entries.each do |le|

      sample = Sample.find(le.sample_id)

      newsample = sample.transfer_to_project(@project, current_user)

      l.add_sample(newsample, current_user) unless l.sample_exists?(newsample)

    end


    ProjectLibrary.new(:project_id => @project.id, :library_id => l.id, :user_id => current_user.id).save


    redirect_to samples_path(:project_id => @project.id, :library_id => l.id)

  end

  def show

    authorize @project_sample, :show?

    @library_entry = LibraryEntry.all.where(["sample_id = ?",  @sample.id]).first

    render 'library_entries/show', :id => @library_entry.id

  end

  def zip

    authorize @project_sample, :show?

    temp_file = Tempfile.new(@sample.id.to_s+".zip")


    Zip::OutputStream.open(temp_file.path) { |zos| 

      zos.put_next_entry("sample_"+@sample.id.to_s+".json")
      zos.print @sample.to_json

        @sample.datasets.each do |dataset|

          dataset.attachments.each do |a|
            zos.put_next_entry(dataset.id.to_s+"/"+a.folder?+a.filename?)
            zos.print a.file.read
          end

        end


    }

    temp_file.close

    send_data(File.read(temp_file.path), :type => 'application/zip', :filename => "sample_"+@sample.id.to_s+".zip")

  end


  def destroy
    authorize @project_sample

    @sample.destroy

    Reaction.find(params[:reaction_id]).update_attribute(:updated_at, DateTime.now)

    redirect_to reaction_url(Reaction.find(params[:reaction_id])), notice: 'Molecule was removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
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

    def set_project_sample
      @project_sample = ProjectSample.where(["project_id = ? AND sample_id = ?", @project.id, @sample.id]).first
    end

    def set_empty_project_sample
      @project_sample = ProjectSample.new(:project_id => @project.id)
    end

    # Only allow a trusted parameter "white list" through.
    def sample_params
      params.require(:sample).permit(:name, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, :molecule_attributes, :compound_id)
    end
end
