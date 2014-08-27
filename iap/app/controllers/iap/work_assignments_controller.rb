require_dependency "iap/application_controller"

module Iap
  class WorkAssignmentsController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug!
    belongs_to :plan, finder: :find_by_number!
    defaults route_prefix: nil
    actions :all, except: :show
    custom_actions resource: :duplicate

    def smart_resource_url
      edit_resource_path
    end

    def duplicate
      new_resource = resource.duplicate
      new_resource.save
      redirect_to edit_resource_path(new_resource)
    end

    protected

    def add_breadcrumbs
      super
      breadcrumb parent.to_breadcrumb, parent_path
      breadcrumb "Planning Worksheets", (params[:id] && collection_path)
      breadcrumb (resource.activity || "New Assignment") if params[:id]
    end

    def build_resource_params
      [params.fetch(:work_assignment, {}).permit(:group, :activity, :district, :section_chief_name, :section_chief_phone,
              :activity_manager_phone, :activity_manager_name, :supervisor_name, :supervisor_phone, :work_assignments,
              :special_instructions, :prepared_by_name, :prepared_by_title,
              work_assignment_lines_attributes: [:resource_identifier, :leader, :num_persons, :contact, :reporting_location, :_destroy, :id])]
    end
  end
end
