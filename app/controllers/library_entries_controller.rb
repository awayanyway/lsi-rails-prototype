class LibraryEntriesController < ApplicationController

  before_action :set_library_entry, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, except: [:index, :show]

  before_action :set_project

  

  def sort
    params[:library_entry].each_with_index do |id, index|
      LibraryEntry.update_all({position: index+1}, {id: id})
    end
    
    render nothing: true
  end


  # GET /library_entries
  def index
    @library_entries = LibraryEntry.all.paginate(:page => params[:page])
  end

  # GET /library_entries/1
  def show
  end

  # GET /library_entries/new
  def new
    @library_entry = LibraryEntry.new
  end

  # GET /library_entries/1/edit
  def edit
  end

  # POST /library_entries
  def create
    @library_entry = LibraryEntry.new(library_entry_params)

    if @library_entry.save
      redirect_to @library_entry, notice: 'Library entry was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /library_entries/1
  def update
    if @library_entry.update(library_entry_params)
      redirect_to @library_entry, notice: 'Library entry was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /library_entries/1
  def destroy
    @library_entry.destroy
    redirect_to library_entries_url, notice: 'Library entry was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library_entry
      @library_entry = LibraryEntry.find(params[:id])
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

    # Only allow a trusted parameter "white list" through.
    def library_entry_params
      params.require(:library_entry).permit(:library_id, :position, :molecule_id, :sample_id)
    end
end
