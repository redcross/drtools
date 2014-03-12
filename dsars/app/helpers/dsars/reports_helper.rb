module Dsars
  module ReportsHelper
    def format val, type
      case type
      when 'currency'
        number_to_currency val, precision: 0
      else
        number_with_delimiter val
      end
    end

    def descr line
      @line_descriptions[line].first.name
    end

    def disabled_row
      safe_join [tag(:td, class: 'disabled'), tag(:td, class: 'disabled'), tag(:td, class: 'disabled'), tag(:td, class: 'disabled end-col')]
    end

    def finance_row line_number
      return disabled_row unless line_number
      line = line_for_num line_number
      desc = line_description line_number

      content_tag(:td, link_to(line.line_number, report_chart_path(parent, @report.report_number, line.line_number))) <<
      content_tag(:td, format(line.period, desc.format), class: "val") <<
      content_tag(:td, format(line.total, desc.format), class: "val") <<
      tag(:td, class: "end-col")
    end

    def line_description num
      @line_descriptions ||= Dsars::LineDescription.where{report_type=='5266'}.group_by(&:line_number)
      @line_descriptions[num].try :first
    end

    def line_for_num num
      @lines_by_number ||= @report.lines.order{line_number}.group_by(&:line_number)
      @lines_by_number[num].first
    end

    def finance_columns
      [
        ["Mass Care PSC21", "Class 2", "Class 3", "Class 4", "Class 6", "Total Client Casework", "Health Svcs Class 5",
          "Mental Health Class 5M", "Safe & Well", "DA/LG/CPS", "Recovery Planning & Asst.", "Total Deductions in CAS",
          "Total Relief Commitments", "OM/FSI/ID/Finance", "Log/DST/Staff", "Fund Raising", "Public Affairs", "Total Operation Commitments",
          "Value of In Kind Donations", "Temp Daily Rental Units", "Temp Monthly Rental Units", "Hotel/Motel Rent Dollars"],
        [nil, 83, 84, 85, 86, 87, 88, 89, nil, nil, 90, 91, 92, nil, nil, nil, nil, 93, nil, 94, 95, 96],
        [97, nil, nil, nil, nil, 98, 99, 100, 101, 102, 103, nil, 104, 105, 106, 107, 108, 109, 110, nil, nil, nil],
        [111, nil, nil, nil, nil, 112, 113, 114, 115, 116, 117, nil, 118, 119, 120, 121, 122, 123, nil, nil, nil, nil],
        (124..145).to_a
      ]
    end
  end
end