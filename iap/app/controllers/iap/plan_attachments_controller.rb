module Iap
  class PlanAttachmentsController < ApplicationController
    inherit_resources
    defaults resource_class: PlanAttachment, route_prefix: nil
    belongs_to :environment, finder: :find_by_slug!
    belongs_to :plan, finder: :find_by_number!
    before_filter :require_draft_plan

    def new_upload
      new!
    end

    protected

    def require_draft_plan
      if parent.approved?
        flash[:error] = "This IAP is approved and cannot be edited."
        redirect_to parent_path
      end
    end

    def add_breadcrumbs
      super
      breadcrumb parent.to_breadcrumb, parent_path
      breadcrumb "Attachment"
    end

    def build_resource_params
      [params.fetch(:plan_attachment, {}).permit(:title, :audience, :attachment_type, :file)]
    end
  end
end