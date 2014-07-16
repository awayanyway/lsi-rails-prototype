class LibrariesController < ApplicationController

  before_filter :authenticate_user!, except: [:index]

  before_action :set_library, only: [:show, :edit, :update, :destroy]

  before_action :set_project

  before_action :set_project_library, only: [:show, :edit, :update, :destroy]


  # GET /libraries
  def index
    @libraries = policy_scope(Library)
  end

  # GET /libraries/1
  def show
    authorize @project_library

    @project_library_entries = @project_library.library.library_entries.paginate(:page => params[:page])
  end

  # GET /libraries/new
  def new
    @library = Library.new

    authorize @project_library
  end

  # GET /libraries/1/edit
  def edit
    authorize @project_library
  end

  # POST /libraries
  def create
    @library = Library.new(library_params)

    authorize @project_library

    if @library.save
      @library.add_to_project(current_user.rootproject_id, current_user)

      redirect_to @library, notice: 'Library was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /libraries/1
  def update
    authorize @project_library

    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to @library, notice: 'Library was successfully updated.' }
        format.json { respond_with_bip(@library) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@library) }
      end
    end
  end

  # DELETE /libraries/1
  def destroy
    authorize @project_library
    @library.destroy
    redirect_to libraries_url, notice: 'Library was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find(params[:id])
    end

    def set_project
      if current_user. nil? then 
        @project = Project.where(["title = ?", "chemotion"]).first
      else
        if params[:project_id].nil? || params[:project_id].empty? then
          @project = current_user.rootproject
        else
          @project = Project.find(params[:project_id])
        end
      end
    end

    def set_project_library
      @project_library = ProjectLibrary.where(["project_id = ? AND library_id = ?", @project.id, @library.id]).first
    end

    # Only allow a trusted parameter "white list" through.
    def library_params
      params.require(:library).permit(:title)
    end
end
