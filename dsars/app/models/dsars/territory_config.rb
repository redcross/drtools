module Dsars
  class TerritoryConfig < ActiveRecord::Base
    belongs_to :incident
  end
end
