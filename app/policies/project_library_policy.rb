class ProjectLibraryPolicy < Struct.new(:user, :project_library)
  class Scope < Struct.new(:user, :project_library)
    def resolve
      user.libraries
    end
  end

  def show?
    result = false
    if !user.nil? && user.libraryviewer_of?(project_library.library) then result = true end

    result
  end

  def create?
    true
  end

  def new?
    true
  end

  def assign?
    user.libraryowner_of?(project_library.library)
  end

  def edit?
    user.libraryowner_of?(project_library.library)
  end

  def update?
    user.libraryowner_of?(project_library.library)
  end

  def destroy?
    user.libraryowner_of?(project_library.library)
  end

end
