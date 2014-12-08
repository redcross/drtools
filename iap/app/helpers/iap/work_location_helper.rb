module Iap
  module WorkLocationHelper
    def work_locations(env)
      env.assigned_staff.select(:work_location).uniq.map(&:work_location).select(&:present?)
    end
  end
end
