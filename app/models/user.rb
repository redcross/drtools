class User < ActiveRecord::Base
  include HasRoles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable, omniauth_providers: [:arcdata]

  belongs_to :region
  has_many :deployments

  default_scope ->{order{[last_name.asc, first_name.asc]}}

  def full_name
    [first_name, last_name].compact.join " "
  end

  def display_name
    "#{last_name}, #{first_name} (#{member_number})"
  end

  def self.find_by_member_number member_number
    find_by member_number: member_number
  end
end
