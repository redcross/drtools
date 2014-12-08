module Iap
  class PlansController < ApplicationController
    inherit_resources
    defaults route_prefix: nil, finder: :find_by_number!
    config[:request_name] = :plan
    belongs_to :environment, finder: :find_by_slug!

    before_filter :require_draft_plan, only: [:edit, :update]
    before_filter :authorize_producer!, except: [:index, :show]

    protected

    def previous_plan
      @previous_plan ||= collection.order{number.desc}.first
    end

    def require_draft_plan
      if resource.approved?
        flash[:error] = "This IAP is approved and cannot be edited."
        redirect_to resource_path
      end
    end

    helper_method :editable?
    def editable?
      !resource.approved?
    end

    def add_breadcrumbs
      super
      case params[:action]
      when 'index' then
      when 'new', 'create' then breadcrumb params[:action].titleize, url_for
      else
        breadcrumb resource.to_breadcrumb
      end
    end

    def build_resource
      super.tap{|res|
        res.number ||= next_plan_number
        res.status ||= 'draft'

        if previous_plan
          previous_plan.work_assignments.each{|wa| 
            new_wa = wa.duplicate
            new_wa.created_at = nil
            new_wa.prepared_by_name = nil
            new_wa.prepared_by_title = nil
            res.work_assignments << new_wa
          }
          res.period_start = previous_plan.period_end
          res.period_end = res.period_start + (previous_plan.period_end - previous_plan.period_start)
        end
      }
    end

    def next_plan_number
      (end_of_association_chain.maximum(:number) || 0) + 1
    end

    def build_resource_params
      [params.fetch(:plan, {}).permit(:number, :period_start, :period_end, :approver_name, :approver_title, :status)]
    end
  end
end