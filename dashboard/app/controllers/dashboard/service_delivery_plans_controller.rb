module Dashboard
  class ServiceDeliveryPlansController < ApplicationController
    inherit_resources
    defaults singleton: true, route_instance_name: :dashboard_sdp, route_prefix: nil
    belongs_to :environment, finder: :find_by_slug!
    actions :new, :edit, :update, :create

    def update
      update! { environment_dashboard_path parent }
    end

    protected

    def add_breadcrumbs
      super
      breadcrumb "Dashboard", environment_dashboard_path(parent)
      breadcrumb "SDP"
    end

    def resource
      @service_delivery_plan ||= ServiceDeliveryPlan.for_environment(parent)
    end

    def build_resource
      @service_delivery_plan ||= begin
        plan = ServiceDeliveryPlan.new(*resource_params)
        plan.environment = parent
        plan
      end
    end

    def permitted_params
      params.permit(:service_delivery_plan => [:approved_budget, :file])
    end
  end
end