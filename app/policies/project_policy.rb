class ProjectPolicy < Struct.new(:user, :project)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.projects.includes(:project_memberships).where(["project_memberships.role_id = ?", 99]).uniq
    end
  end

  class JointScope < Struct.new(:user, :scope)
    def resolve
      user.projects.includes(:project_memberships).where(["project_memberships.role_id < ?", 99]).uniq
    end
  end

  def show?
        result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 88 then result = true end
    end

    result

  end

  def create?
    true
  end

  def new?
    true
  end

  def addsample?
    result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 96 then result = true end
    end

    result

  end

  def addmolecule?
    result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 96 then result = true end
    end

    result

  end

  def addreaction?
    result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 96 then result = true end
    end

    result


  end

  def adddataset?
    result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 96 then result = true end
    end

    result

  end

  def adduser?
        result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 99 then result = true end
    end

    result

  end

  def removeuser?
        result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 99 then result = true end
    end

    result

  end

  def edit?
        result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 99 then result = true end
    end

    result

  end

  def update?
        result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 99 then result = true end
    end

    result

  end

  def destroy?
        result = false

    if !user.nil? then
      project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project.id, user.id]).first

      if project_membership.role_id >= 99 then result = true end

      if user.rootproject_id == project.id then result = false end
    end

    result

  end

end
