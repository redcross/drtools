module Iap
  class ApprovalsController < ApplicationController
    inherit_resources
    defaults route_prefix: nil, finder: :find_by_number!, collection_name: 'plans', route_instance_name: :plan_approval
    config[:request_name] = :plan
    belongs_to :environment, finder: :find_by_slug!
    prepend_before_filter :set_id

    actions :new, :create, :destroy, :update

    before_filter :authorize_approver!

    def destroy
      resource.approver_name = resource.approver_title = resource.approved_at = nil
      resource.status = 'draft'
      update!
    end

    protected

    def set_id
      params[:id] = params.delete :plan_id
    end

    def build_resource
      @plan ||= resource.tap do |plan|
        plan.send :attributes=, *resource_params
        plan.approver_name = current_user.full_name unless plan.approver_name.present?
        plan.approved_at = Time.current
        plan.status = 'approved'
      end
    end

    def build_resource_params
      [params.fetch(:plan, {}).permit(:approver_name, :approver_title)]
    end
  end
end