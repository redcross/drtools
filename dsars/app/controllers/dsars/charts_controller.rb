module Dsars
  class ChartsController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug

    def show
      @incident = params[:incident_id]
      @line_number = params[:id]

      @report = end_of_association_chain.first

      parent_report = @report

      @line_description = LineDescription.where{(report_version == my{@report.report_version}) & (line_number == my{@line_number})}.first
      @lines = ReportLine.joins{report}.where{(line_number == my{@line_number}) &
                                              (report.incident_number == parent_report.incident_number) &
                                              (report.scope == parent_report.scope) &
                                              (report.unit_id == parent_report.unit_id) &
                                              (report.county_id == parent_report.county_id)
                                              }.order{report.report_number}.includes{report}.to_a

      breadcrumb "Report #{@report.report_number}", report_path(parent, @report.report_number)
      breadcrumb @line_description.name
    end

    def end_of_association_chain
      Report.where{(report_type == '5266')}.where{dro_number == my{parent.dr_number}}.consolidated
    end


    private

    helper_method :series_data
    def series_data col
      vals = @lines.map do |line|
        date = to_js_date(line.report.cob_date)
        val = line[col].to_json
        "[#{date}, #{val}]"
      end.compact

      "[#{vals.join ','}]"
    end

    helper_method :chart_title
    def chart_title
      "#{parent.name} - 5266 Report #{@report.cob_date} - #{@line_description.try :name}"
    end

    def to_js_date(d)
      "Date.UTC(#{d.year}, #{d.month-1}, #{d.day})"
    end
  end
end