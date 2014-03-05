class UserEnvironment < ActiveRecord::Base
  belongs_to :user
  belongs_to :environment
end
