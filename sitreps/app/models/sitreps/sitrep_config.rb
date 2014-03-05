module Sitreps
  class SitrepConfig < ActiveRecord::Base
    belongs_to :environment
    has_many :prompts, -> { order(:ordinal) }
    accepts_nested_attributes_for :prompts, allow_destroy: true

    validates :environment, presence: true

    def self.for_environment env
      find_by environment_id: env
    end

    def self.find_or_initialize_for_environment env
      find_or_initialize_by environment_id: env.id
    end
  end
end
