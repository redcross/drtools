class RegionEnvironment < ActiveRecord::Base
  belongs_to :environment
  belongs_to :region

  validates :environment, :region, presence: true
  validates :region_id, uniqueness: {scope: :environment_id}
end
