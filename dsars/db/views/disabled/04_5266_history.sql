CREATE OR REPLACE VIEW line5266_history AS SELECT
line5266s.*,
(SELECT array_agg(data.period) period_history from 
  (SELECT coalesce(rep.period, 0) as period, rep.report_number FROM dsars_line5266s  rep
            WHERE rep.scope=line5266s.scope 
            and rep.unit_id=line5266s.unit_id 
            and rep.county_id=line5266s.county_id 
            and rep.line_number=line5266s.line_number
            and rep.incident_number=line5266s.incident_number
            and line5266s.report_number >= rep.report_number 
            ORDER BY rep.report_number asc) data) as period_history,
(SELECT array_agg(data.total) total_history from 
  (SELECT coalesce(rep.total, 0) as total, rep.report_number FROM dsars_line5266s  rep
            WHERE rep.scope=line5266s.scope 
            and rep.unit_id=line5266s.unit_id 
            and rep.county_id=line5266s.county_id 
            and rep.line_number=line5266s.line_number
            and rep.incident_number=line5266s.incident_number
            and line5266s.report_number >= rep.report_number 
            ORDER BY rep.report_number asc) data) as total_history
FROM dsars_line5266s
ORDER BY territory_ordinal, territory_name asc, line_number asc
;