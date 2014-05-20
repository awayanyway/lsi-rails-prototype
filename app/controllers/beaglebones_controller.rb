class BeaglebonesController < ApplicationController
  before_action :set_beaglebone, only: [:assign, :assign_do, :show, :edit, :update, :destroy]

  before_filter :authenticate_user!, except: [:heartbeat]

  protect_from_forgery :except => [:heartbeat]

  
  def heartbeat

    @bb = OpenStruct.new

    @beaglebones = Beaglebone.where (["serialnumber = ?", params[:serialnumber]])

    if (@beaglebones.first) then

      @bb = @beaglebones.first

      @devices = Device.where (["beaglebone_id = ?", @bb])

      if (@bb) then

        @bb.update_attribute(:last_seen, Time.now)

        @bb.update_attribute(:internal_ip, params[:beaglebone][:ipaddress])

        @bb.update_attribute(:external_ip, request.remote_ip)

        if (@devices.last) then

          @bb = OpenStruct.new(:id => @bb.id, :serialnumber => @bb.serialnumber)

          @bb.device = @devices.last

          @bb.devicetype = @devices.last.devicetype
        end

      end

    end

    render json: @bb
  end

  def index
    @beaglebones = BeaglebonePolicy::Scope.new(current_user, Beaglebone).resolve

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beaglebones }
    end
  end

  def assign

    authorize @beaglebone

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @beaglebone }
    end
  end

  def assign_do

    authorize @beaglebone, :assign?

    @project = Project.find(params[:project_id])

    @beaglebone.add_to_project(@project.id, current_user)

    redirect_to beaglebone_path(@beaglebone), notice: "BeagleBone was assigned to project."
  end   


  # GET /beaglebones/1
  # GET /beaglebones/1.json
  def show
    @beaglebone = Beaglebone.find(params[:id])

    authorize @beaglebone

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beaglebone }
    end
  end

  # GET /beaglebones/new
  # GET /beaglebones/new.json
  def new
    @beaglebone = Beaglebone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beaglebone }
    end
  end

  # GET /beaglebones/1/edit
  def edit
    @beaglebone = Beaglebone.find(params[:id])
  end

  # POST /beaglebones
  # POST /beaglebones.json
  def create
    @beaglebone = Beaglebone.new(params[:beaglebone])

    authorize @beaglebone

    respond_to do |format|
      if @beaglebone.save

        @beaglebone.add_to_project(current_user.rootproject_id, current_user)

        format.html { redirect_to @beaglebone, notice: 'Beaglebone was successfully created.' }
        format.json { render json: @beaglebone, status: :created, location: @beaglebone }
      else
        format.html { render action: "new" }
        format.json { render json: @beaglebone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beaglebones/1
  # PUT /beaglebones/1.json
  def update
    @beaglebone = Beaglebone.find(params[:id])

    authorize @beaglebone

    respond_to do |format|
      if @beaglebone.update_attributes(params[:beaglebone])
        format.html { redirect_to @beaglebone, notice: 'Beaglebone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beaglebone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beaglebones/1
  # DELETE /beaglebones/1.json
  def destroy
    @beaglebone = Beaglebone.find(params[:id])

    authorize @beaglebone

    @beaglebone.destroy

    respond_to do |format|
      format.html { redirect_to beaglebones_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beaglebone
      @beaglebone = Beaglebone.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def beaglebone_params
      params.require(:beaglebone).permit(:serialnumber, :internal_ip, :last_seen, :external_ip, :version)
    end
end
