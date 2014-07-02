class Measurement < ActiveRecord::Base
  attr_accessible :dataset_id, :device_id, :sample_id, :recorded_at, :reaction_id, :molecule_id, :title

  attr_accessible :user_id, :confirmed, :samplename

  belongs_to :dataset
  belongs_to :device
  belongs_to :sample

  belongs_to :user


  has_many :runs
  has_many :locations, :through => :runs

  before_create do

    self.title = "New measurement"

  end

  def finished?

    samplename == "finished"

  end

  def complete?

    res = false
    if !(self.sample_id.nil?) then res = true end

    res
  end

  def confirmed?
    self.confirmed
  end

  def assign_to_user

    ui = self.dataset.title.scan(/[A-Z]{3}|[A-Z]{2}/).first

    user = User.where(["sign = ?", ui]).first

    if !user.nil? then

      self.update_attribute(:user_id, user.id)

      return true

    end

    return false

  end

  def guess_user_sample_name(user)

    if !dataset.nil? then

      nr = self.dataset.title.scan(/\d+/)

      self.update_attribute(:samplename, nr.join("-"))

      nr.join("-")

    else ""

    end

  end

  def guess_user_sample_id(user)

    if !dataset.nil? then

    nr = self.dataset.title.scan(/\d+/)

    if !nr.first.nil? then

    r = user.samples.where(["name ilike ?", "%"+user.sign+"-"+nr.first+"%"]).first

    if !r.nil? then r.id.to_s
    else
      ""
    end

    else ""
    end

    else ""

    end

  end

  def guess_samplename

    nr = self.dataset.title.scan(/\d+/)

    self.update_attribute(:samplename, nr.join("-"))

    nr.join("-")

  end

  def guess_reaction_name

    nr = self.dataset.title.scan(/\d+/)

    nr.first

  end

  def guess_user_reaction_name(user)

    nr = self.dataset.title.scan(/\d+/)

    if !nr.first.nil? then

    user.sign+"-"+nr.first

    else ""

    end

  end

  def guess_user_reaction_id(user)

    nr = self.dataset.title.scan(/\d+/)

    if !nr.first.nil? then

    r = user.reactions.where(["name ilike ?", "%"+user.sign+"-"+nr.first+"%"]).first

    if !r.nil? then r.id.to_s
    else
      ""
    end

    else ""
    end

  end
  

  def update_creationdate
  	cd = DateTime.new(1982, 11, 10)

        if dataset.recorded_at.nil? then        

          dataset.attachments.each do |a|

            if a.filechange > cd then

              cd = a.filechange

            end
          end

        else
          cd = dataset.recorded_at
        end

        self.update_attribute(:recorded_at, cd)


    end
end
