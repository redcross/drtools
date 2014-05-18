require_dependency "iap/application_controller"

module Iap
  class PlanningWorksheetsController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug!
    belongs_to :plan, finder: :find_by_number!
    defaults route_prefix: nil
    actions :all, except: :show

    def smart_resource_url
      edit_resource_path
    end

    protected

    def add_breadcrumbs
      super
      breadcrumb parent.to_breadcrumb, parent_path
      breadcrumb "Planning Worksheets", (params[:id] && collection_path)
      breadcrumb (resource.activity || "New Worksheet") if params[:id]
    end

    def build_resource_params
      [params.fetch(:planning_worksheet, {}).permit(:district, :group, :activity, :prepared_by_name, :prepared_by_title, :completed,
          planning_worksheet_lines_attributes: [:_destroy, :id, :work_assignment, :location,
            planning_worksheet_resources_attributes: [:ordinal, :requested, :have, :need, :resource, :id]])]
    end
  end
end
