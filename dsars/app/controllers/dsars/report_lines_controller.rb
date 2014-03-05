class ReportLinesController < ApplicationController

  def lines
    @reports = Report.where(report_type: '5266', dro_number: params[:incident_id], scope: ['Consolidated', 'Chapter'])
    @lines = ReportLine.where(report_id: @reports, line_number: params[:line_number])
  end

end
