DROP VIEW IF EXISTS dsars_dosr_lines CASCADE;
CREATE OR REPLACE VIEW dsars_dosr_lines AS SELECT
  dosr_configs.name, dosr_configs.dosr_line_number, dosr_configs.format,
  reports.dro_number, reports.report_number, reports.cob_date, reports.incident_name,
  reports.incident_number,
  environments.id as environment_id, territories.id as territory_id,
  sum(report_lines.period) as period, sum(report_lines.total) as total
FROM dsars_reports reports
LEFT JOIN dsars_report_lines report_lines ON reports.id=report_lines.report_id 
INNER JOIN dsars_dosr_configs dosr_configs ON report_lines.line_number = ANY( dosr_configs.lines)
LEFT JOIN territory_scopes ts ON (
  CASE
  WHEN ts.scope_type='consolidated' THEN reports.scope='Consolidated'
  WHEN ts.scope_type='chapter' THEN reports.scope='Chapter' AND reports.unit_id=ts.unit_code
  WHEN ts.scope_type='county' THEN reports.scope='County' AND reports.county_id=ts.unit_code
  ELSE false
  END
)
LEFT JOIN territories ON ts.territory_id=territories.id
LEFT JOIN environments ON environments.dsars_incident_number=reports.incident_number AND environments.id=territories.environment_id
WHERE reports.report_type='5266'
    AND dosr_configs.enabled='t'
    AND (dosr_configs.environment_id = environments.id 
        OR (dosr_configs.environment_id IS NULL 
            AND NOT EXISTS(SELECT 1 FROM dsars_dosr_configs dc WHERE dc.environment_id=environments.id)
           )
        )
    AND ts.id is not null
GROUP BY dosr_configs.name, dosr_configs.dosr_line_number, dosr_configs.format,
reports.dro_number, reports.report_number, reports.cob_date, reports.incident_name, reports.incident_number,
environments.id, territories.id;