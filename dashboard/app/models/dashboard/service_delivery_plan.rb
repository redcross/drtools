module Dashboard
  class ServiceDeliveryPlan < ActiveRecord::Base
    belongs_to :environment
    has_attached_file :file
    validates_attachment_file_name :file, matches: [/xlsm?\z/]
    validates :environment, :file, presence: true
    validates :environment_id, uniqueness: true

    def self.for_environment env
      find_by environment_id: env
    end
  end
end
