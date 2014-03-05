module Dsars
  class Report < ActiveRecord::Base
    has_many :lines, class_name: 'ReportLine'
    has_one :dda, class_name: 'ReportDDA'

    def self.consolidated
      where(scope: 'Consolidated')
    end
  end
end
