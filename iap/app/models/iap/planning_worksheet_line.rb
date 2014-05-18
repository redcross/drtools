module Iap
  class PlanningWorksheetLine < ActiveRecord::Base
    belongs_to :planning_worksheet
    has_many :planning_worksheet_resources
    accepts_nested_attributes_for :planning_worksheet_resources, allow_destroy: true

    def resource_line ordinal
      planning_worksheet_resources.detect{|res| res.ordinal == ordinal}
    end
  end
end
