SELECT fu2.record_id,
       fu2.screening_id,
       fu2.wra_ptid,
       fu2.last_visit_date,
       'Second Follow-Up' as visit_name,
       fu2.attempt_number as attempts_completed,
       fu2.follow_up_visit_date,
       fu2.follow_up_last_visit_date,
       fu2.follow_up_visit_date_days_late
FROM (SELECT v1.record_id,
             v1.screening_id,
             v1.wra_ptid,
             COALESCE(v3.visit_date, v1.screening_date)                                    as last_visit_date,
             IF(v3.attempt_number IS NULL OR v3.attempt_number = '', 0, v3.attempt_number) as attempt_number,
             DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY)                           as follow_up_visit_date,
             DATE_ADD(v1.screening_date, INTERVAL (90 + (90 + 21)) DAY)                    as follow_up_last_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY))                 as follow_up_visit_date_days_late
      FROM vw_wra_baseline_visit_overview v1
               LEFT JOIN vw_wra_second_fu_visit_overview v3 ON v1.record_id = v3.record_id
      WHERE v1.record_id NOT IN (SELECT v2.record_id FROM vw_wra_first_fu_visit_overview v2)
        AND v1.record_id NOT IN (SELECT v3.record_id
                                 FROM vw_wra_second_fu_visit_overview v3
                                 WHERE v3.visit_status IN (
                                                           'Yes', 'Available', 'Migrated', 'Extended-Absence',
                                                           'Physical/Mental-Impairment', 'No, has migrated',
                                                           'Untraceable',
                                                           'Other {wra_fu_is_wra_avail_other_f2}'
                                     ))
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY)) < 21
      UNION
      SELECT v2.record_id,
             v2.screening_id,
             v2.wra_ptid,
             COALESCE(v3.visit_date, v2.visit_date)                                        as last_visit_date,
             IF(v3.attempt_number IS NULL OR v3.attempt_number = '', 0, v3.attempt_number) as attempt_number,
             DATE_ADD(v2.visit_date, INTERVAL ((90)) DAY)                                  as follow_up_visit_date,
             DATE_ADD(v2.visit_date, INTERVAL ((90 + 21)) DAY)                             as follow_up_last_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v2.visit_date, INTERVAL ((90)) DAY))                        as follow_up_visit_date_days_late
      FROM vw_wra_first_fu_visit_overview v2
               LEFT JOIN vw_wra_second_fu_visit_overview v3 ON v2.record_id = v3.record_id
      WHERE v2.record_id NOT IN (SELECT v3.record_id
                                 FROM vw_wra_second_fu_visit_overview v3
                                 WHERE v3.visit_status IN (
                                                           'Yes', 'Available', 'Migrated', 'Extended-Absence',
                                                           'Physical/Mental-Impairment', 'No, has migrated',
                                                           'Untraceable',
                                                           'Other {wra_fu_is_wra_avail_other_f2}'
                                     ))
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL (90) DAY)) <= 21) fu2
ORDER BY fu2.follow_up_visit_date_days_late