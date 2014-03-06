CREATE OR REPLACE VIEW dsars_dosr_history AS SELECT
dsars_dosr_lines.*,
(SELECT array_agg(data.period) period_history from 
  (SELECT coalesce(rep.period, 0) as period, rep.report_number FROM dsars_dosr_lines  rep
            WHERE rep.territory_id=dsars_dosr_lines.territory_id
                AND rep.dosr_line_number=dsars_dosr_lines.dosr_line_number
                AND dsars_dosr_lines.report_number >= rep.report_number 
            ORDER BY rep.report_number asc) data
) as period_history,
(SELECT array_agg(data.total) total_history from 
  (SELECT coalesce(rep.total, 0) as total, rep.report_number FROM dsars_dosr_lines  rep
             WHERE rep.territory_id=dsars_dosr_lines.territory_id
                AND rep.dosr_line_number=dsars_dosr_lines.dosr_line_number
                AND dsars_dosr_lines.report_number >= rep.report_number 
            ORDER BY rep.report_number asc) data
) as total_history
FROM dsars_dosr_lines
ORDER BY dosr_line_number asc
;