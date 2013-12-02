class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  attr_accessible :firstname, :lastname, :sign

  attr_accessible :skip_invitation


  #affiliations

  attr_accessible :affiliations_attributes

  has_many :user_affiliations
  has_many :affiliations,
    through: :user_affiliations

  accepts_nested_attributes_for :affiliations

  def affiliations_attributes=(attrib)

    attrib.each do |ind, affi|

      a = Affiliation.new

      newaffiliation_country = Country.find_or_create_by_title(affi[:country_title])

      newaffiliation_organization = newaffiliation_country.organizations.find_or_create_by_title(affi[:organization_title])

      newaffiliation_department = newaffiliation_organization.departments.find_or_create_by_title(affi[:department_title])

      newaffiliation_group = newaffiliation_department.groups.find_or_create_by_title(affi[:group_title])

      newaffiliation_country.save
      newaffiliation_organization.save
      newaffiliation_department.save
      newaffiliation_group.save

      if !newaffiliation_country.organizations.exists? (newaffiliation_organization) then
        newaffiliation_country.organizations << newaffiliation_organization
      end

      if !newaffiliation_organization.departments.exists? (newaffiliation_department) then
        newaffiliation_organization.departments << newaffiliation_department
      end

      if !newaffiliation_department.groups.exists? (newaffiliation_group) then
        newaffiliation_department.groups << newaffiliation_group
      end

      a.country = newaffiliation_country
      a.organization = newaffiliation_organization
      a.department = newaffiliation_department
      a.group = newaffiliation_group

      a.save

      affiliations << a

    end
  end


  # projects
  attr_accessible :rootproject_id

  after_create :create_rootproject

  has_many :project_memberships, :foreign_key => :user_id

  has_many :projects,
    through: :project_memberships, :foreign_key => :user_id

  has_one :rootproject

  def create_rootproject
    rp = Project.create!
    rp.save

    pm = ProjectMembership.new
    pm.user_id = self.id
    pm.project_id = rp.id
    pm.role_id = 99
    pm.save

    update_attributes(:rootproject_id => rp.id)

  end

  def projectowner_of?(project)
    project_memberships.exists?(:user_id => id, :project_id => project.id, :role_id => 99)
  end

  def projectmember_of?(project)
    project_memberships.exists?(:user_id => id, :project_id => project.id, :role_id => 88)
  end


  # elements associated with project

  has_many :project_molecules
  has_many :molecules,
    through: :project_molecules

  def molecules
    Molecule.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def moleculeviewer_of?(molecule)
    Project.joins(:project_memberships).joins(:molecules).where(["project_memberships.role_id >= ? and molecule_id = ? and project_memberships.user_id = ?", 88, molecule.id, id]).exists?
  end

  def moleculeowner_of?(molecule)
    Project.joins(:project_memberships).joins(:molecules).where(["project_memberships.role_id >= ? and molecule_id = ? and project_memberships.user_id = ?", 99, molecule.id, id]).exists?
  end

end
