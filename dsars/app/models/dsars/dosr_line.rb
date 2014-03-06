module Dsars
  class DosrLine < ActiveRecord::Base
    self.table_name = "dsars_dosr_history"
    belongs_to :environment
    belongs_to :territory

    def readonly?
      true
    end
  end
end