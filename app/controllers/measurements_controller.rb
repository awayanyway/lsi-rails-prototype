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

  def new

    @measurement = Measurement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @measurement }
    end
  end

  def edit

    @measurement = Measurement.find(params[:id])
    
    authorize @measurement, :edit?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @measurement }
    end
  end

  def create

    if params[:measurement][:sample_id] == -2 then

      @sample = Sample.new(:name => params[:sample_name])

      @sample.save

      @sample.add_to_project_recursive(current_user.rootproject_id, current_user)

      params[:measurement][:sample_id] = @sample.id


    elsif params[:measurement][:sample_id] == -1 then

      params[:measurement][:sample_id] = nil

    end

    if params[:measurement][:device_id] == -1 then

      params[:measurement][:device_id] = nil      

    end


    @measurement = Measurement.new(params[:measurement])

    authorize @measurement

    @measurement.user_id =  current_user.id


    respond_to do |format|
      if @measurement.save

        format.html { redirect_to measurements_path, notice: 'Measurement was successfully initialized.' }
        format.json { render json: @measurement, status: :created, location: @measurement }
      else
        format.html { render action: "new" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end


  def assign_molecule

    @measurement = Measurement.find(params[:id])


    if params[:molecule_id].empty? then 

        @measurement.update_attribute(:molecule_id, nil)

        redirect_to import_measurement_path(@measurement), notice: "Measurement was removed from molecule." 

    else

      @measurement.update_attribute(:molecule_id, params[:molecule_id])


      redirect_to import_measurement_path(@measurement), notice: "Measurement was assigned to molecule." 

    end

  end

  def assign_sample
    @measurement = Measurement.find(params[:id])

    if !params[:sample_name].blank? then 

      # creation mode

      @sample = Sample.new(:name => params[:sample_name])

      @sample.save


      #@reaction.samples.each do |s|          

       #   s.molecule.add_to_project(current_user.rootproject_id) 
       #   s.add_to_project(current_user.rootproject_id)
       # end

      @sample.add_to_project_recursive(current_user.rootproject_id, current_user)


      @measurement.update_attribute(:sample_id, @sample.id)

      @measurement.sample.add_dataset(@measurement.dataset, current_user)


      redirect_to import_measurement_path(@measurement), notice: "Measurement was assigned to new sample." 

    else

      # assign mode

      if params[:sample_id].empty? then 

        @measurement.update_attribute(:sample_id, nil)

        redirect_to import_measurement_path(@measurement), notice: "Measurement was removed from sample." 

      else

      @measurement.update_attribute(:sample_id, params[:sample_id])

      @measurement.sample.add_dataset(@measurement.dataset, current_user)

      redirect_to import_measurement_path(@measurement), notice: "Measurement was assigned to sample." 

      end

    end


    
  end

  def assign_reaction
    @measurement = Measurement.find(params[:id])

    if !params[:reaction_name].blank? then 

      # creation mode

      @reaction = Reaction.new(:name => params[:reaction_name])

      @reaction.save


      #@reaction.samples.each do |s|          

       #   s.molecule.add_to_project(current_user.rootproject_id) 
       #   s.add_to_project(current_user.rootproject_id)
       # end

      @reaction.add_to_project(current_user.rootproject_id)


      @measurement.update_attribute(:reaction_id, @reaction.id)


      redirect_to import_measurement_path(@measurement), notice: "Measurement was assigned to new reaction." 

    else

      # assign mode

      if params[:reaction_id].empty? then 

        @measurement.update_attribute(:reaction_id, nil)

        redirect_to import_measurement_path(@measurement), notice: "Measurement was removed from reaction." 

      else

      @measurement.update_attribute(:reaction_id, params[:reaction_id])


      # check if reaction has one product, then assign it to this one

      @reaction = Reaction.find(params[:reaction_id])

      if @reaction.products.length == 1 then 

        @measurement.update_attribute(:molecule_id, @reaction.products.first.molecule_id)

      end

      redirect_to import_measurement_path(@measurement), notice: "Measurement was assigned to reaction." 

      end

    end


    
  end


  def update

    @measurement = Measurement.find(params[:id])

    @measurement.update_attributes(:user_id => current_user.id)

    @measurement.save

    if params[:measurement][:sample_id] == -2 then

      @sample = Sample.new(:name => params[:sample_name])

      @sample.save

      @sample.add_to_project_recursive(current_user.rootproject_id, current_user)


      @measurement.update_attribute(:sample_id, @sample.id)

      @measurement.sample.add_dataset(@measurement.dataset, current_user)      

    elsif params[:measurement][:sample_id] == -1 then

      @measurement.update_attribute(:sample_id, nil)

    else

      @measurement.update_attribute(:sample_id, params[:measurement][:sample_id])

    end

    if params[:measurement][:device_id] == -1 then

      params[:measurement][:device_id] = nil      

    end

    params[:measurement].delete :sample_id

    if @measurement.update_attributes(params[:measurement]) then

      redirect_to measurements_path

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

      # @ds.update_attribute(:molecule_id,  @measurement.molecule_id)


      # assign_version_to_dataset @dataset, Molecule.find(@measurement.molecule_id)

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
