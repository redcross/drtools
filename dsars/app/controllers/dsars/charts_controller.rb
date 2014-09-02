module Dsars
  class ChartsController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug

    class LineInfo
      attr_reader :parent_report, :line_description, :lines
      def initialize(parent_report, line_description)
        @parent_report = parent_report
        @line_description = line_description
        @lines = ReportLine.joins{report}.where{(line_number == line_description.line_number) &
                                              (report.incident_number == parent_report.incident_number) &
                                              (report.scope == parent_report.scope) &
                                              (report.unit_id == parent_report.unit_id) &
                                              (report.county_id == parent_report.county_id)
                                              }.order{report.report_number}.includes{report}.to_a
      end

      def series_data col
        vals = @lines.map do |line|
          date = to_js_date(line.report.cob_date)
          val = line[col].to_json
          "[#{date}, #{val}]"
        end.compact

        "[#{vals.join ','}]"
      end

      def to_js_date(d)
        "Date.UTC(#{d.year}, #{d.month-1}, #{d.day})"
      end

      def chart_title
        "5266 Report #{parent_report.cob_date} - #{line_description.try :name}"
      end
    end

    def show
      @incident = params[:incident_id]

      @report = end_of_association_chain.first

      @line_numbers = params[:id].split ','
      @lines = @line_numbers.map do |line_no|
        line_description = LineDescription.where{(report_version == my{@report.report_version}) & (line_number == my{line_no})}.first
      
        if line_description.format == 'currency'
          authorize! Roles::Dsars::FINANCIALS
        end

        LineInfo.new @report, line_description
      end

      breadcrumb "Report #{@report.report_number}", report_path(parent, @report.report_number)
      breadcrumb @lines.first.line_description.name
    end

    def end_of_association_chain
      Report.where{(report_type == '5266')}.where{dro_number == my{parent.dr_number}}.consolidated
    end


    private

    helper_method :chart_title

  end
end