class DevicePolicy < Struct.new(:user, :device)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.devices
    end
  end

  def show?
    user.deviceviewer_of?(device)
  end

  def control?
    user.deviceviewer_of?(device)
  end

  def create?
    true
  end

  def checkin?
    user.deviceviewer_of?(device)
  end

  def checkinselect?
    user.deviceviewer_of?(device)
  end

  def edit?
    user.deviceowner_of?(device)
  end

  def update?
    user.deviceowner_of?(device)
  end

  def destroy?
    user.deviceowner_of?(device)
  end

  def assign?
    user.deviceowner_of?(device)
  end

  def connect?
    user.deviceowner_of?(device)
  end

end
