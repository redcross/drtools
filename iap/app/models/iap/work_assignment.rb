module Iap
  class WorkAssignment < ActiveRecord::Base
    belongs_to :plan
    has_many :work_assignment_lines
    accepts_nested_attributes_for :work_assignment_lines, allow_destroy: true

    def duplicate
      new_ass = self.dup
      work_assignment_lines.each do |line|
        new_ass.work_assignment_lines << line.dup
      end
      new_ass
    end
  end
end
