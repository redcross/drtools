module Iap
  module PlanAttachmentsHelper

    def attachment_type_options
      [
        ['Plan', 'plan', {data: {default_name: default_plan_name}}],
        ['Situation Report', 'sitrep'],
        ['Other', 'other']
      ]
    end

    def default_plan_name
      pp parent
      [current_environment.dr_number, current_environment.name, "IAP #{parent.number} #{parent.period_start.to_date.to_s :date}"].compact.join ' '
    end

  end
end