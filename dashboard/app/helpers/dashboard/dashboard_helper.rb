module Dashboard
  module DashboardHelper
    def incident_name
      @report.incident_name
    end

    def lines
      @lines ||= @report.lines.group_by(&:line_number)
    end

    def period_value line_number, default=nil
      line = lines[line_number].first
      line && line.period || default
    end

    def total_value line_number, default=nil
      line = lines[line_number].first
      line && line.total || default
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

    def assigned_staff_by_gap
      @staff ||= current_environment.assigned_staff.to_a.group_by{|as| as.group}.merge(current_environment.assigned_staff.to_a.group_by{|as| "#{as.group}/#{as.activity}"})
      @staff.default = []
      @staff
    end

    def efficiency_model
      {
        "Shelter Overnight Stays" => {line: 17, default_weight: 10, gap: 'MC', cost_basis: [124], noun: 'stays'},
        "Health Services Contacts" => {line: 75, default_weight: 40, gap: 'CLS/HS', cost_basis: [99,113], noun: 'contacts'},
        "Mental Health Contacts" => {line: 79, default_weight: 40, gap: 'CLS/DMH', cost_basis: [100, 114], noun: 'contacts'},
        "Cases Open" => {line: 60, default_weight: 5, gap: 'CLS/CC', cost_basis: [98, 112], noun: 'open cases'},
        "Individual Financial Assistance" => {line: 92, default_weight: 0.1, gap: 'CLS/CC', cost_basis: [98, 112], noun: 'dollars provided'}
      }
    end

    def overhead
      @overhead ||= [132, 133, 103, 117, 137, 138, 139, 140].map{|line| total_value(line, 0) }.sum
    end

    def total_weight
      efficiency_model.map{|name, model|
        weight = weight(name, model)
        total_value(model[:line], 0) * weight
      }.sum
    end

    def weight name, model
      param = name.to_param
      (params.key?(param) ? params[param].to_f : model[:default_weight])
    end
  end
end