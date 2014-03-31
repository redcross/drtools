class UserEnvironment < ActiveRecord::Base
  include HasRoles

  belongs_to :user
  belongs_to :environment

  def self.for_user_environment user, environment
    where{(user_id == user) & (environment_id == environment)}
  end

  before_validation :update_user_info
  def update_user_info
    if user
      self.member_number = user.member_number
    else
      self.user = User.find_by_member_number self.member_number
    end
  end

  def title
    name = if user
      user.display_name
    else
      "Member #{member_number}"
    end
    name << ":"
    name << roles_string
  end
end
