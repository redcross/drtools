module Dsars
  class ReportLine < ActiveRecord::Base
    belongs_to :report
  end
end