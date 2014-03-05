class RegionEnvironment < ActiveRecord::Base
  belongs_to :region
  belongs_to :environment
end
