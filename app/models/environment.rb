class Environment < ActiveRecord::Base
  include SerializedColumns
  has_many :territories
  has_many :region_environments
  has_many :user_environments

  serialized_accessor :config, :enable_dsars, :boolean
  serialized_accessor :config, :enable_sitreps, :boolean
  serialized_accessor :config, :enable_dashboard, :boolean
  serialized_accessor :config, :enable_cop, :boolean
  serialized_accessor :config, :enable_iap, :boolean
  serialized_accessor :config, :time_zone_raw, :string

  def self.active
    where{enabled == true}
  end

  def time_zone
    @tz ||= ActiveSupport::TimeZone[time_zone_raw]
  end

  def to_param
    slug
  end

  def to_breadcrumb
    short_name
  end

  def component_enabled? component
    self.send "enable_#{component}"
  end

  include Iap::EnvironmentAdditions
end
