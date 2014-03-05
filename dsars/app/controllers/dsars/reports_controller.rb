module Dsars
  class ReportsController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug!
    defaults finder: :find_by_report_number

    def index
      incident = params[:incident_id]
      @reports = end_of_association_chain.order{report_number.desc}.to_a
    end

    def show
      @incident = params[:incident_id]
      @report_num = params[:id]
      @report = end_of_association_chain.where{(report_number == my{@report_num})}.first
    end

    protected

    def add_breadcrumbs
      super
      if params[:action] != 'index'
        breadcrumb "Report #{params[:id]}", reports_path(parent, params[:id])
      end
    end

    def end_of_association_chain
      Report.where{(report_type == '5266')}.where{dro_number == my{parent.dr_number}}.consolidated
    end
  end
end