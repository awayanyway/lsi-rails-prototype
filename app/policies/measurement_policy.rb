class MeasurementPolicy < Struct.new(:user, :measurement)
  class Scope < Struct.new(:user, :measurement)
    def resolve
      user.measurements
    end
  end

  def show?
    result = false
    if !user.nil? && measurement.user_id == user.id then result = true end

    result
  end

  def create?
    true
  end

  def new?
    true
  end

  def edit?
    result = false
    if !user.nil? && measurement.user_id == user.id then result = true end

    result
  end

  def update?
    result = false
    if !user.nil? && measurement.user_id == user.id then result = true end

    result
  end

  def destroy?
    result = false
    if !user.nil? && measurement.user_id == user.id then result = true end

    result
  end

end
