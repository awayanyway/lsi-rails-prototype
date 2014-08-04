class ProjectsController < ApplicationController
  
  before_filter :authenticate_user!

  def invite
    @project = Project.find(params[:id])

    authorize @project, :adduser?

    respond_to do |format|
      format.html { render action: "invite" }
      format.json { head :no_content }
    end
  end

  def adduser
    @project = Project.find(params[:id])

    authorize @project

    if (!params[:user_id].nil?) then

      additionaluser = User.find(params[:user_id])

    else

      additionaluser = User.where(["email = ?", params[:email]]).first

      if (additionaluser.nil?) then

        User.invite!(:email => params[:email]) do |u|
          additionaluser = u
        end

        
      end

    end

    if (!params[:role_id].nil?) then

      role_id = params[:role_id]

    else

      role_id = 88

    end


    pm = ProjectMembership.new
    pm.user = additionaluser
    pm.project = @project
    
    pm.role_id = role_id
    pm.save

    respond_to do |format|
      
        format.html { redirect_to projects_path, notice: 'User was successfully added to the Project.' }
        format.json { head :no_content }
      
    end

  end

  def removeuser
    @project = Project.find(params[:id])

    authorize @project

    if params[:user_id].to_s != current_user.id.to_s then

      ProjectMembership.where(["user_id = ? and project_id = ?", params[:user_id], @project.id]).destroy_all

    end
    

    respond_to do |format|
      
        format.html { redirect_to projects_path, notice: 'User was successfully removed from the Project.' }
        format.json { head :no_content }
      
    end

  end


  # GET /projects
  # GET /projects.json
  def index
    @projects =  ProjectPolicy::Scope.new(current_user, Project).resolve.order("created_at ASC")
    @jointprojects =  ProjectPolicy::JointScope.new(current_user, Project).resolve.order("created_at ASC")

    @current_user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    authorize @project

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    @project.parent_id = params[:parent_id]

    authorize @project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])

    authorize @project
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    authorize @project

    respond_to do |format|
      if @project.save

        pm = ProjectMembership.new
        pm.user = current_user
        pm.project = @project
        pm.role_id = 99
        pm.save

        @project.create_rootlibrary(current_user)

        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    authorize @project

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])

    authorize @project
    
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def import

    @project = Project.find(params[:id])

    authorize @project, :show?

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def importzip

    @project = Project.find(params[:id])

    importtype = params["upload"]["type"]

    authorize @project, :show?


    samples = []

    reactions = []

    Zip::File.open(params[:upload][:file].path) do |zip_file|

      zip_file.each do |entry|

        if entry.name.start_with?("sample") && importtype == "samples" then 

          samples << JSON.parse(entry.get_input_stream.read)

        end

        if entry.name.start_with?("reaction") && importtype == "reactions" then 

          reactions << JSON.parse(entry.get_input_stream.read)

        end
      end

      reactions.each do |r|

        r.delete("id")
        r.delete("created_at")
        r.delete("updated_at")
        r.delete("molecule_id")
        r.delete("guid")

        samples = r["samples"]

        r.delete("samples")

        reaction = Reaction.new(r)

        reaction.save


        samples.each do |sa|


          sample = addsample(@project, sa, zip_file)

          reaction.samples << sample

        end


        @project.add_reaction(reaction, current_user)
        


      end


      samples.each do |s|

        addsample(@project, s, zip_file)
        
      end


    end

    if importtype == "samples" then redirect_to "/samples?project_id=" + @project.id.to_s end 

    if importtype == "reactions" then redirect_to "/reactions?project_id=" + @project.id.to_s end

    if importtype == "datasets" then redirect_to "/datasets?project_id=" + @project.id.to_s end

  end

  private

  def adddataset(project, ds, zip_file)

    ds.delete("version")
            ds.delete("molecule_id")

            old_dataset_id = ds["id"]
            ds.delete("id")

            ds.delete("position")
            ds.delete("uniqueid")
            ds.delete("id")
            ds.delete("created_at")
            ds.delete("updated_at")
            ds.delete("sample_id")


            attachments = ds["attachments"]
            ds.delete("attachments")

            dataset = Dataset.new(ds)

            dataset.save

            dsg = Datasetgroup.new
            dsg.save
            dsg.datasets << dataset


            attachments.each do |att|

              newattachment = Attachment.new(:dataset => dataset)

              puts "ATT"
              puts att

              newattachment.folder = att["folder"]

              if Rails.env.localserver? or Rails.env.development? then 

                localpath = LsiRailsPrototype::Application.config.datasetroot + "datasets/#{dataset.id}/#{att["folder"]}#{att["filename"]}"

                FileUtils.mkdir_p(File.dirname(localpath))

                zip_file.extract(old_dataset_id.to_s+"/"+att["filename"] , localpath)

                newattachment.file = File.new(localpath)
                newattachment.save


              else
                localpath = Rails.root.join('tmp').join(att["filename"])

                File.delete(localpath) if File.exist?(localpath)

                FileUtils.mkdir_p(File.dirname(localpath))

                zip_file.extract(old_dataset_id.to_s+"/"+att["filename"] , localpath)

                newattachment.file = File.open(localpath)
                newattachment.save

                File.delete(localpath) if File.exist?(localpath)
              end

              dataset.add_attachment(newattachment)

            end

            project.add_dataset(dataset, current_user)

            return dataset

  end

  def addsample(project, s, zip_file)

        s.delete("id")
        s.delete("created_at")
        s.delete("updated_at")
        s.delete("molecule_id")
        s.delete("guid")

               
        datasets = []

        dx = s["datasets"]        

        s.delete("datasets")

        if !s["molecule"].blank? then

                  s["molecule"].delete("id")
        s["molecule"].delete("created_at")
        s["molecule"].delete("updated_at")

        @molecule = Molecule.new(s["molecule"])

          virtualmolecule = Rubabel::Molecule.from_string(@molecule.molfile, :mdl)
          
          existingmolecules = Molecule.where (["inchikey = ?", virtualmolecule.to_s(:inchikey).gsub(/\n/, "").strip])
          existingmolecule = existingmolecules.first

          if (existingmolecule != nil) then
            if (existingmolecule.id != nil) then
              success = true
              @molecule = existingmolecule

            end
          else
            success = @molecule.save
            
          end

        end

        s.delete("molecule")

        if success then 

          sample = Sample.new(s)

          sample.molecule = @molecule

          sample.save
          @molecule.samples << sample


          dx.each do |ds|

            sample.add_dataset(adddataset(project, ds, zip_file), current_user)

          end

          project.add_sample(sample, current_user)

        end

      return sample
  end
end
