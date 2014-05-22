class ReactionsController < ApplicationController

  before_filter :authenticate_user!

  before_action :set_reaction, only: [:show, :edit, :update, :destroy, :assign, :assign_do, :zip]

  before_action :set_project

  before_action :set_project_reaction, only: [:show, :edit, :update, :destroy, :assign, :zip]

  before_action :set_empty_project_reaction, only: [:createdirect, :create, :new, :assign_do]

  # GET /reactions
  def index

    @project_reactions = ProjectReaction.where(["project_id = ?", @project.id]).paginate(:page => params[:page])

    @analytics = nil
  end

   def assign

    authorize @project_reaction, :show?

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @reaction }
    end
  end

  def assign_do

    authorize @project_reaction, :assign?

    if !params[:remove].nil? then

      @project.remove_reaction_only(@reaction)

      redirect_to reactions_path(:project_id => params[:project_id]), notice: "Reaction and corresponding samples were removed from project."

    else

      @project.add_reaction(@reaction, current_user)

      redirect_to reaction_path(@reaction, :project_id => params[:project_id]), notice: "Reaction and corresponding samples were assigned to project."

    end

    
  end   

  def zip

    authorize @project_reaction, :show?

    temp_file = Tempfile.new(@reaction.id.to_s+".zip")


    Zip::OutputStream.open(temp_file.path) { |zos| 

      zos.put_next_entry("reaction_"+@reaction.id.to_s+".json")
      zos.print @reaction.to_json

      @reaction.samples.each do |sample|

        sample.datasets.each do |dataset|

          dataset.attachments.each do |a|
            zos.put_next_entry(dataset.id.to_s+"/"+a.folder?+a.filename?)
            zos.print a.file.read
          end

        end

      end


    }

    temp_file.close

    send_data(File.read(temp_file.path), :type => 'application/zip', :filename => "reaction_"+@reaction.name.to_s+".zip")

  end

  # GET /reactions/1
  def show
    authorize @project_reaction, :show?

    if !current_user.nil? then @owndatasets = @reaction.datasets end

    if !params[:render].blank? && params[:render] == "inline" then 

        @device = Device.find(params[:device_id])

        render "showbalance", :layout => false

        return

    end
  end

  def createdirect
    @reaction = Reaction.new

    authorize @project_reaction, :create?

    namearray = Array.new

    current_user.reactions.each do |r|
      namearray << r.name
    end

    puts namearray

    if (current_user.sign != nil) then 

      stillsearching = true
      c = 1

      while stillsearching
        suggestedname = current_user.sign + "-" + c.to_s

        if !namearray.include?(suggestedname) then
          stillsearching = false
        end
        c = c + 1
        
      end

      @reaction.name = suggestedname
    end

    if @reaction.save

        @project.add_reaction(@reaction, current_user)

        redirect_to reaction_path(@reaction, :project_id => @project.id), notice: 'Reaction was successfully created.'

    else
      render action: 'new'
    end
  end

  # GET /reactions/new
  def new
    @reaction = Reaction.new

    authorize @project_reaction, :new

    namearray = Array.new

    current_user.reactions.each do |r|
      namearray << r.name
    end

    puts namearray

    if (current_user.sign != nil) then 

      stillsearching = true
      c = 1

      while stillsearching
        suggestedname = current_user.sign + "-" + c.to_s

        if !namearray.include?(suggestedname) then
          stillsearching = false
        end
        c = c + 1
        
      end

      @reaction.name = suggestedname
    end

  end

  # GET /reactions/1/edit
  def edit
    authorize @project_reaction, :edit?
  end

  # POST /reactions
  def create
    @reaction = Reaction.new(reaction_params)

    authorize @project_reaction, :create?


    if @reaction.save



        @reaction.samples.each do |s|          

          s.molecule.add_to_project(current_user.rootproject_id, current_user) 
          s.add_to_project(current_user.rootproject_id, current_user)
        end


        @reaction.add_to_project(current_user.rootproject_id, current_user)


      redirect_to @reaction, notice: 'Reaction was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /reactions/1
  def update
    authorize @project_reaction, :update?

    if @reaction.update(reaction_params)


      @reaction.update_attribute(:updated_at, DateTime.now)

      redirect_to @reaction, notice: 'Reaction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /reactions/1
  def destroy
    authorize @project_reaction, :destroy?

    @reaction.destroy
    redirect_to reactions_path(:project_id => @project.id), notice: 'Reaction was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reaction
      @reaction = Reaction.find(params[:id])
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

    def set_project_reaction
      @project_reaction = ProjectReaction.where(["project_id = ? AND reaction_id = ?", @project.id, @reaction.id]).first
    end

    def set_empty_project_reaction
      @project_reaction = ProjectReaction.new(:project_id => @project.id)
    end

    # Only allow a trusted parameter "white list" through.
    def reaction_params
      params.require(:reaction).permit(:name, :description, 

        :products_attributes => [:id, :_destroy, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id], 

        :educts_attributes => [:id, :_destroy, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id],

        :reactants_attributes => [:id, :_destroy, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id])
    end
end
