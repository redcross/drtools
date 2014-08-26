module Iap
  class WorkAssignment < ActiveRecord::Base
    belongs_to :plan
    has_many :work_assignment_lines
    accepts_nested_attributes_for :work_assignment_lines, allow_destroy: true
  end
end
