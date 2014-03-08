module Dsars
  class Importer
    def initialize(username, password, logger=Rails.logger)
      @dsars = Dsars5266.new
      @dsars.login username, password
      @dda = Dsars5233.new
      @dda.cookies = @dsars.cookies
      @logger = logger
    end

    attr_reader :dsars, :dda, :consolidated_only, :block
    attr_accessor :logger

    def import(incident_number, since: nil, report_number: nil, consolidated_only: false, &block)
      @consolidated_only = consolidated_only
      @block = block

      filters = {since: since, report_number: report_number}

      import_5266_reports(get_reports(dsars, '5266', incident_number, filters))
      import_5233_reports(get_reports(dda,   '5233', incident_number, filters))

      log "Done"
      @block = nil
    end

    def log msg
      Rails.logger.info msg
      block.call msg if block
    end

    def get_reports(client, type, incident_number, since: nil, report_number: nil)
      logger.info "Listing #{type} reports for incident #{incident_number}"
      reports = client.list_reports(incident_number)
      if report_number
        reports = reports.select{|r| r.report_number == report_number}
      elsif since
        reports = reports.select{|r| r.cob_date >= since }
      else
        existing_dates = Report.where(report_type: type, incident_number: incident_number).uniq.pluck(:cob_date).flatten
        reports = reports.reject{|r| existing_dates.include?(r.cob_date)}
      end
      logger.info "Will pull reports for #{reports.map(&:cob_date).map(&:to_s).join ', '}"
      reports
    end

    def import_5266_reports reports
      reports.each do |list_item|
        log "Processing 5266 for #{list_item.cob_date}\n"

        report = list_item.report

        if consolidated_only
          scopes = [report.consolidated]
        else
          scopes = report.scopes
        end

        scopes.each do |scope|
          report5266 = find_or_initialize_report report, '5266', scope
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
            [report5266.id, line_no, val[:period], val[:total]]
          end

          ReportLine.import [:report_id, :line_number, :period, :total], lines

        end
      end
    end

    def import_5233_reports reports
      reports.each do |report|
        log "Processing 5233 for #{report.cob_date}\n"
        report.report.scopes.each do |scope|
          report5233 = find_or_initialize_report(report, '5233', scope, 'County')
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

      def find_or_initialize_report(report, report_type, scope, scope_name=nil)
        Report.find_or_initialize_by report_type: '5233',
                                     incident_number: report.incident_number, 
                                     report_number: report.report_number,
                                     scope: scope_name || scope.type,
                                     unit_id: scope.unit_id,
                                     unit_name: scope.unit_name,
                                     county_id: scope.county_id,
                                     county_name: scope.county_name
      end
    end
  end
end