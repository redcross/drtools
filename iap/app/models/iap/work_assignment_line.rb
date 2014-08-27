module Iap
  class WorkAssignmentLine < ActiveRecord::Base
    belongs_to :work_assignment
    default_scope ->{order{ordinal}}
  end
end
