module Iap
  class Plan < ActiveRecord::Base
    belongs_to :environment
    validates :number, presence: true, uniqueness: {scope: :environment_id}
    validates :approver_name, :approver_title, presence: {if: :approved?}

    has_many :plan_attachments, dependent: :destroy

    assignable_values_for :status do
      %w(draft approved)
    end

    def self.for_environment env
      where{environment_id == env}
    end

    def self.draft
      where{status == 'draft'}
    end

    def self.approved
      where{status == 'approved'}
    end

    def self.upcoming now=Time.zone.now
      approved.where{period_start >= now}
    end

    def self.current now=Time.zone.now
      approved.where{(period_start <= now) & (period_end > now)}
    end

    def self.past now=Time.zone.now
      approved.where{period_end < now}
    end

    def to_param
      number
    end

    def to_breadcrumb
      "##{number}"
    end

    def approved?
      status == 'approved'
    end
  end
end
