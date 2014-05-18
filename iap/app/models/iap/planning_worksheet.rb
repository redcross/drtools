module Iap
  class PlanningWorksheet < ActiveRecord::Base
    belongs_to :plan
    has_many :planning_worksheet_lines
    accepts_nested_attributes_for :planning_worksheet_lines, allow_destroy: true
  end
end
