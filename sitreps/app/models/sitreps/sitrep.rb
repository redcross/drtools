module Sitreps
  class Sitrep < ActiveRecord::Base
    belongs_to :environment
    belongs_to :creator
    has_many :responses, ->{ order{ordinal} }

    accepts_nested_attributes_for :responses, update_only: true

    validates :date, :activity, :submitter_name, :submitter_title, presence: true

    def self.for_environment env
      where{environment_id == env}
    end

  end
end
