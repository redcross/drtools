module Dashboard
  class DashboardController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug!
    def show
      @report = Dsars::Report.where(report_type: '5266', dro_number: parent.dr_number, scope: 'Consolidated').order{report_number.desc}.first
      @sdp = ServiceDeliveryPlan.for_environment parent
    end

    protected

    def add_breadcrumbs
      breadcrumb "Dashboard"
    end
  end
end