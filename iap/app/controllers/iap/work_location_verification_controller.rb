module Iap
  class WorkLocationVerificationController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug!
    belongs_to :plan, finder: :find_by_number!
    defaults route_prefix: nil#, singleton: true
    actions :show

    def show

    end

    protected

    def resource
      @resource ||= WorkLocationVerification.new(parent)
    end

    def add_breadcrumbs
      super
      breadcrumb parent.to_breadcrumb, environment_plan_path(current_environment, parent)
      breadcrumb "Work Locations"
    end

  end
end