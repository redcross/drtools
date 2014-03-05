module Dsars
  class Importer
    def self.import(username, password, dr_number, since=nil, consolidated_only: false, &block)
      dsars = Dsars5266.new
      dsars.login username, password

      reports = dsars.list_reports(dr_number)
      if since
        reports = reports.select{|r| r.cob_date >= since }
      else
        existing_dates = Report.where(report_type: '5266', dro_number: dr_number).uniq.pluck(:cob_date)
        reports = reports.reject{|r| existing_dates.include?(r.cob_date)}
      end

      reports.each do |list_item|
        block.call "Processing 5266 for #{list_item.cob_date}\n"

        report = list_item.report

        if consolidated_only
          scopes = [report.consolidated]
        else
          scopes = report.scopes
        end

        scopes.each do |scope|
          report5266 = Report.where( report_type: '5266',
                                     incident_number: list_item.incident_number, 
                                     report_number: list_item.report_number,
                                     scope: scope.type,
                                     unit_id: scope.unit_id,
                                     unit_name: scope.unit_name,
                                     county_id: scope.county_id,
                                     county_name: scope.county_name).first_or_initialize
          report5266.update_attributes({
            dro_number: list_item.dro_number,
            incident_name: list_item.incident_name,
            report_number: list_item.report_number,
            dsars_id: list_item.report_id,
            cob_date: list_item.cob_date,
            report_version: report.version
          })

          report5266.lines.delete_all
          lines = (1..(report.num_lines)).map do |line_no|
            val = scope[line_no]
            report5266.lines.build(line_number: line_no, period: val[:period], total: val[:total])
          end

          ReportLine.import lines

        end
      end

      dda = Dsars5233.new
      dda.cookies = dsars.cookies

      reports = dda.list_reports(dr_number)
      reports = reports.select{|r| r.cob_date >= since } if since
      reports.each do |report|
        block.call "Processing 5233 for #{report.cob_date}\n"
        report.report.scopes.each do |scope|
          report5233 = Report.where( report_type: '5233',
                                     incident_number: report.incident_number, 
                                     report_number: report.report_number,
                                     scope: 'County',
                                     unit_id: scope.unit_id,
                                     unit_name: scope.unit_name,
                                     county_id: scope.county_id,
                                     county_name: scope.county_name).first_or_initialize
          report5233.update_attributes({
            dro_number: report.dro_number,
            incident_name: report.incident_name,
            report_number: report.report_number,
            dsars_id: report.report_id,
            cob_date: report.cob_date
          })

          report5233.dda.try(:destroy)
          data = report5233.build_dda
          data.attributes = scope.attributes.slice(*data.attributes.keys)
          data.save!
        end
      end

      block.call "Done"
    end
  end
end