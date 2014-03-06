CREATE OR REPLACE VIEW dsars_line5266s AS SELECT
  dsars_reports.unit_id, dsars_reports.county_id, dsars_reports.county_name,
  dsars_reports.dro_number, dsars_reports.report_number, dsars_reports.cob_date, dsars_reports.incident_name,
  dsars_reports.scope, coalesce(territory_configs.name) as territory_name, territory_configs.description as territory_description,
  territory_configs.ordinal as territory_ordinal,
  dsars_reports.incident_number,
  report_lines.line_number, report_lines.period, report_lines.total
FROM dsars_reports 
LEFT JOIN dsars_report_lines ON dsars_reports.id=dsars_report_lines.report_id 

LEFT OUTER JOIN territory_configs ON (dsars_reports.incident_number=territory_configs.incident_number 
                        AND dsars_reports.scope=territory_configs.scope AND dsars_reports.unit_id=territory_configs.unit_id
                        AND dsars_reports.county_id=territory_configs.county_id)
WHERE dsars_reports.report_type='5266'
ORDER BY territory_configs.ordinal, report_lines.line_number;


  line_descriptions.name,

INNER JOIN dsars_line_descriptions ON report_lines.line_number=line_descriptions.line_number AND dsars_reports.report_version=line_descriptions.report_version