module Iap
  class PlanningWorksheetResource < ActiveRecord::Base
    belongs_to :planning_worksheet_line
  end
end
