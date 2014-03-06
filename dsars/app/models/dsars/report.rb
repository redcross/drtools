module Dsars
  class Report < ActiveRecord::Base
    has_many :lines, class_name: 'ReportLine'
    has_one :dda, class_name: 'ReportDDA'

    def self.consolidated
      where(scope: 'Consolidated')
    end

    def self.form5266
      where(report_type: '5266')
    end
  end
end
