class MeasurementsController < ApplicationController

  before_filter :authenticate_user!

  # GET /datasets
  # GET /datasets.json
  def index
    @measurements =  Measurement.where(["user_id = ? and confirmed = ?", current_user.id, false]).paginate(:page => params[:page]).order ("recorded_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @measurements }
    end
  end

  def assign_molecule

    @measurement = Measurement.find(params[:id])

    @measurement.update_attribute(:molecule_id, params[:molecule_id])

    redirect_to import_measurement_path(@measurement), notice: "Molecule was assigned to measurement." 
  end

  def assign_reaction
    @measurement = Measurement.find(params[:id])

    @measurement.update_attribute(:reaction_id, params[:reaction_id])

    redirect_to import_measurement_path(@measurement), notice: "Reaction was assigned to measurement." 
  end


  def import

    @measurement = Measurement.find(params[:id])

    @measurement.update_attributes(:user_id => current_user.id)

    @measurement.save

    respond_to do |format|
        format.html { render action: "import" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
  end

  def discard

    @measurement = Measurement.find(params[:id])

    @measurement.update_attributes(:user_id => nil)

    @measurement.save


    # assign measurement to user

    # create suggestion

    # check if reaction exists

    # check if molecule exists

    # if all requirements are fulfilled, mark measurement as completed

    redirect_to measurements_path, notice: 'Measurement was discarded.'
  end


  def confirm

    @measurement = Measurement.find(params[:id])

    if @measurement.complete? then

      @ds = @measurement.dataset

      @r = Reaction.find(@measurement.reaction_id)

      @r.projects.each do |p|
        @ds.add_to_project (p.id)
      end

      @ds.update_attribute(:molecule_id,  @measurement.molecule_id)


      # assign_version_to_dataset @dataset, Molecule.find(@measurement.molecule_id)


      dm = ReactionDataset.new
      dm.reaction_id = @measurement.reaction_id
      dm.dataset_id = @ds.id
      dm.save

      @measurement.update_attribute(:confirmed, true)
      

      redirect_to @measurement.dataset, notice: "Measurement was imported."
    else
      respond_to do |format|
        format.html { render action: "import", notice: "Measurement assignment is not yet complete." }

      end
    end
  end


  private 

  def assign_version_to_dataset (dataset, molecule)

    similarmethoddatasets = molecule.datasets.where(["method = ?", dataset.method])
    dataset.version = (similarmethoddatasets.length).to_s

  end
end