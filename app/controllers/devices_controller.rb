class DevicesController < ApplicationController

  before_filter :authenticate_user!, except: [:showcase, :showcaseindex]

  before_action :set_device, only: [:assign, :assign_do, :show, :edit, :update, :destroy, :stoprun, :startrun, :control, :share, :invite, :checkin, :checkinselect, :checkout, :connect, :connectit]

  # GET /devices
  # GET /devices.json
  def index
    @devices = DevicePolicy::Scope.new(current_user, Device).resolve
    # @devices = Device.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @devices }
    end
  end

  def control
    authorize @device, :control?
  end

def assign

    authorize @device

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @device }
    end
  end

  def assign_do

    authorize @device, :assign?

    @project = Project.find(params[:project_id])

    @device.add_to_project(@project.id, current_user)

    redirect_to device_path(@device), notice: "Device was assigned to project."
  end   

  def connect
    authorize @device, :connect?
    

    respond_to do |format|
      format.html
      format.json { render json: @device }
    end
  end

  def connectit
    authorize @device, :connect?

    if (!params[:vncrelay_id].nil? && !params[:vncrelay_id].empty?) then

      @device.connectiontype = "vnc"

      @device.vnchost = params[:vnchost]
      @device.vncport = params[:vncport]
      @device.vncpassword = params[:vncpassword]

      @device.vncrelay_id = params[:vncrelay_id]

      @device.save

      redirect_to device_path(@device), notice: "Device connected via VNC."

    elsif (params[:beaglebone_serialnumber] == "") then

      @device.connectiontype = "simulation"

      @device.save

      redirect_to device_path(@device), notice: "Device set to simulation mode."

    else

      @device.connectiontype = "serial"
        
      @device[:beaglebone_id] = params[:beaglebone_id]  

      @device.save   

      redirect_to device_path(@device), notice: "Connect device to Beaglebone #"+params[:beaglebone_id]+"."

    end

  end

  def checkinselect
    authorize @device, :checkinselect?
    @samples = Sample.all

    respond_to do |format|
      format.html
      format.json { render json: @device }
    end
  end

  def checkin
    authorize @device, :checkin?
    @sample = Sample.find (params[:sample_id])

    l = @device.locations.first
    l.sample_id = @sample.id
    l.save

    redirect_to samplelocations_at_device_path(@device)
  end

  def checkout
    authorize @device, :checkin?
    @sample = Sample.find (params[:sample_id])

    l = @device.locations.first
    l.sample_id = nil
    l.save

    redirect_to samplelocations_at_device_path(@device)
  end

  def samplelocations
    @device = Device.find(params[:id])

    authorize @device, :show?

    @locations = @device.locations

    @locations.each do |location|
        
    end

    render 'devices/samplelocations', :layout => false
  end

  def startrun

    Run.create! do |run|
           run.user_id = current_user.id
           run.device_id = @device.id
           run.location_id = params[:location_id]
           run.active = true;
        end

    redirect_to device_path(@device), notice: "Run started."
  end

  def stoprun

    Rails.logger.info (params)

    @locations = Location.where (["device_id = ?", params[:id]])

    @locations.each do |location|
        @runs = Run.where (["location_id = ?", location.id])

        @runs.each do |therun|

          if therun.active
            therun.active = false
            therun.save
          end

        end
    end

    redirect_to device_path(@device), notice: "Run stopped."
  end  

  # GET /devices/1
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    authorize @device, :show?

    # @operation = @device.operations.create

    @locations = @device.locations

    @locations.each do |location|
        # @runs = Run.where (["location_id = ?", location.id])

        # @runs.each do |therun|

          # if therun.active
          #   @run = therun
          # end

        # end
    end

    @measurements = Measurement.where(["device_id = ?", @device.id]).paginate(:page => params[:page], :per_page => 10).order ("recorded_at DESC")


    respond_to do |format|
      format.html { render action: "show", notice: "" }
      format.json { render json: @device }
    end
  end

  def showvnc
    @device = Device.find(params[:id])

    authorize @device, :show?

    # @operation = @device.operations.create

    @locations = @device.locations

    @locations.each do |location|
        # @runs = Run.where (["location_id = ?", location.id])

        # @runs.each do |therun|

          # if therun.active
          #   @run = therun
          # end

        # end
    end

    respond_to do |format|
      format.html { render :layout => false, notice: "" }
      format.json { render json: @device }
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def showcase

    devicetypes = Devicetype.where (["name = ?", params[:device_type]])

    devicetype = devicetypes.first

    @device = Device.new(:devicetype_id => devicetype.id, :connectiontype =>"simulation");
    @device.id = 9999
    @device.name = "Device Demonstration"

    location = Location.new

    @locations = Array.new

    @locations.push @location
    
    respond_to do |format|
      format.html { render action: "show", notice: "" }
      format.json { render json: @device }
    end
  end

  def showcaseindex

    @devicetypes = Devicetype.where(["showcase = ?", true])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /devices/new
  # GET /devices/new.json
  def new

    devicescount = current_user.devices.count + 1

    @device = Device.new

    @device.name = "my device "+devicescount.to_s

    @simpleselect = true;

    @devicetypes = Devicetype.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
    authorize @device, :edit?

    @devicetypes = Devicetype.all
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(params[:device])

    authorize @device, :create?
    
    @device.porttype = @device.devicetype.porttype
    @device.portname = @device.devicetype.portname
    @device.portbaud = @device.devicetype.portbaud
    @device.portdetails = @device.devicetype.portdetails  

    respond_to do |format|
      if @device.save

        @device.add_to_project(current_user.rootproject_id, current_user)

        @device.locations << Location.create do |devloc|
          
        end

        format.html { redirect_to connect_device_path (@device), notice: 'Device was successfully created.' }
        format.json { render json: @device, status: :created, location: @device }
      else
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.json
  def update
    @device = Device.find(params[:id])

    authorize @device, :update?

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device = Device.find(params[:id])
    authorize @device, :destroy?

    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def device_params
      params.require(:device).permit(:name, :connectiontype, :portbaud, :portdetails, :portname, :porttype, :devicetype_id, :beaglebone_id, :lastseen, :websockifygateway, :websockifygatewayport, :vnchost, :vncport, :token, :vncpassword)
    end
end
