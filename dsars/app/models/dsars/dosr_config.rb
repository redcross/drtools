module Dsars
  class DosrConfig < ActiveRecord::Base
    belongs_to :environment

    def self.for_environment(env)
      not_exists = self.where{environment_id == env}.exists.not
      where{(environment_id == nil) | ((environment_id == nil) & not_exists)}
    end
  end
end
