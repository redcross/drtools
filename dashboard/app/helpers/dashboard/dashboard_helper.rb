module Dashboard
  module DashboardHelper
    def incident_name
      @report.incident_name
    end

    def lines
      @lines ||= @report.lines.group_by(&:line_number)
    end

    def period_value line_number
      line = lines[line_number].first
      line && line.period
    end

    def total_value line_number
      line = lines[line_number].first
      line && line.total
    end

    def period_indirect
      (period_value(141) || 0) - (period_value(92) || 0) - (period_value(97) || 0)
    end

    def total_indirect
      (total_value(141) || 0) - (total_value(92) || 0) - (total_value(97) || 0)
    end

    def chart_link line, text
      link_to (text || ""), dsars.report_chart_path(parent, @report.report_number, line)
    end
  end
end