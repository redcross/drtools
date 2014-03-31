module Dsars
  class DosrController < ApplicationController
    inherit_resources
    helper ReportsHelper
    def show
      @environment = Environment.find_by_slug! params[:environment_id]
      report_num = params[:report_id]
      @report = Report.form5266.consolidated.where{(report_number==report_num) & (incident_number==my{@environment.dsars_incident_number})}.first
      @lines = DosrLine.where{(environment_id == my{@environment}) & (report_number==report_num) & ((period != nil) | (total != nil))}.includes{territory}.order{dosr_line_number}
      @lines.sort_by!{|l| [l.territory.ordinal, l.dosr_line_number]}
      @lines_by_territory = @lines.group_by(&:territory)
      line_numbers = @lines.map(&:dosr_line_number).uniq
      @configs = DosrConfig.for_environment(@environment).where{dosr_line_number.in line_numbers}.order{dosr_line_number}
    end

    protected

    def match_territory  report
      @scopes.detect do |scope|
        case scope.scope_type
        when 'consolidated' then report.scope == 'Consolidated'
        when 'chapter' then report.scope == 'Chapter' && report.unit_id == scope.unit_code
        when 'county' then report.scope == 'County' && report.county_id == scope.unit_code
        else false
        end
      end.try(:territory)
    end

    def add_breadcrumbs
      super
      breadcrumb "DOSR"
    end
  end
end