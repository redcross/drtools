module Iap
  class PlanAttachment < ActiveRecord::Base
    belongs_to :plan
    has_attached_file :file
    do_not_validate_attachment_file_type :file

    #validates :file, presence: true

    assignable_values_for :audience do
      %w(all internal leadership)
    end

    assignable_values_for :attachment_type do
      %w(plan sitrep other)
    end
  end
end
