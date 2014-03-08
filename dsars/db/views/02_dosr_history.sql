DROP VIEW IF EXISTS dsars_dosr_history;
CREATE OR REPLACE VIEW dsars_dosr_history AS 
SELECT dsars_dosr_lines.*,
(SELECT array_agg(data.period) FROM 
  (SELECT coalesce(rep.period, 0) as period, coalesce(rep.total, 0) as total, rep.report_number FROM dsars_dosr_lines  rep
            WHERE rep.incident_number=dsars_dosr_lines.incident_number
                AND rep.territory_id=dsars_dosr_lines.territory_id
                AND rep.dosr_line_number=dsars_dosr_lines.dosr_line_number
                AND dsars_dosr_lines.report_number >= rep.report_number 
            ORDER BY rep.report_number asc) data
) as period_history
FROM dsars_dosr_lines
ORDER BY dosr_line_number asc
;