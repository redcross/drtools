class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable, omniauth_providers: [:arcdata]

  belongs_to :region

  def full_name
    [first_name, last_name].compact.join " "
  end
end
