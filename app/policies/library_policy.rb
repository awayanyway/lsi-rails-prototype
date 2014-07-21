class LibraryPolicy < Struct.new(:user, :library)
  class Scope < Struct.new(:user, :library)
    def resolve
      user.libraries
    end
  end

  def show?
    result = false
    if !user.nil? && user.libraryviewer_of?(library) then result = true end

    result
  end

  def create?
    true
  end

  def new?
    true
  end

  def assign?
    result = false
    if !user.nil? && user.libraryowner_of?(library) then result = true end

    result
  end

  def edit?
    result = false
    if !user.nil? && user.libraryowner_of?(library) then result = true end

    result
  end

  def update?
    result = false
    if !user.nil? && user.libraryowner_of?(library) then result = true end

    result
  end

  def destroy?
    result = false
    if !user.nil? && user.libraryowner_of?(library) then result = true end

    result
  end

end
