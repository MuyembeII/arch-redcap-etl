/**
 * WRA Informed Consent Overview.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 28.02.25
 * @since 0.0.1
 * @alias WRA Consent Tracker
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_consent_overview
AS
WITH wra_fu_1_consent AS
         (SELECT v2.*,
                 IF(f1.wra_fu_conf_consent = 1, 'Yes',
                    IF(f1.wra_fu_conf_consent = 0, 'No', f1.wra_fu_conf_consent)) as ongoing_consent_confirmed,
                 IF(f1.wra_fu_reas_decline_const = 4,
                    CONCAT_WS(' - ', 'Other', f1.fu_reason_decline_other),
                    f1.wra_fu_reas_decline_const_label)                           as consent_declined_reason
          FROM crt_wra_visit_2_overview v2
                   LEFT JOIN wra_follow_up_visit_repeating_instruments f1
                             ON v2.alternate_id = f1.wra_follow_up_visit_repeating_instruments_id
          WHERE f1.wra_fu_conf_consent IN (0, 1)
          GROUP BY v2.visit_number, v2.visit_date, v2.screening_id
          ORDER BY v2.visit_date DESC),
     wra_fu_2_consent AS
         (SELECT v3.*,
                 IF(f2.wra_fu_conf_consent_f2 = 1, 'Yes',
                    IF(f2.wra_fu_conf_consent_f2 = 0, 'No', f2.wra_fu_conf_consent_f2)) as ongoing_consent_confirmed,
                 IF(f2.wra_fu_reas_decline_f2 = 4,
                    CONCAT_WS(' - ', 'Other', f2.fu_reason_decline_other_f2),
                    f2.wra_fu_reas_decline_f2_label)                                    as consent_declined_reason
          FROM crt_wra_visit_3_overview v3
                   LEFT JOIN wra_follow_up_visit_2_repeating_instruments f2
                             ON v3.alternate_id = f2.wra_follow_up_visit_2_repeating_instruments_id
          WHERE f2.wra_fu_conf_consent_f2 IN (0, 1)
          GROUP BY v3.visit_number, v3.visit_date, v3.screening_id
          ORDER BY v3.visit_date DESC),
     wra_fu_3_consent AS
         (SELECT v4.*,
                 IF(f3.wra_fu_conf_consent_f3 = 1, 'Yes',
                    IF(f3.wra_fu_conf_consent_f3 = 0, 'No', f3.wra_fu_conf_consent_f3)) as ongoing_consent_confirmed,
                 IF(f3.wra_fu_reas_decline_const_f3 = 4,
                    CONCAT_WS(' - ', 'Other', f3.fu_reason_decline_other_f3),
                    f3.wra_fu_reas_decline_const_f3_label)                              as consent_declined_reason
          FROM crt_wra_visit_4_overview v4
                   LEFT JOIN wra_follow_up_visit_3_repeating_instruments f3
                             ON v4.alternate_id = f3.wra_follow_up_visit_3_repeating_instruments_id
          WHERE f3.wra_fu_conf_consent_f3 IN (0, 1)
          GROUP BY v4.visit_number, v4.visit_date, v4.screening_id
          ORDER BY v4.visit_date DESC),
     wra_fu_4_consent AS
         (SELECT v5.*,
                 IF(f4.wra_fu_conf_consent_f4 = 1, 'Yes',
                    IF(f4.wra_fu_conf_consent_f4 = 0, 'No', f4.wra_fu_conf_consent_f4)) as ongoing_consent_confirmed,
                 IF(f4.wra_fu_reas_decline_const_f4 = 4,
                    CONCAT_WS(' - ', 'Other', f4.fu_reason_decline_other_f4),
                    f4.wra_fu_reas_decline_const_f4_label)                              as consent_declined_reason
          FROM crt_wra_visit_5_overview v5
                   LEFT JOIN wra_follow_up_visit_4_repeating_instruments f4
                             ON v5.alternate_id = f4.wra_follow_up_visit_4_repeating_instruments_id
          WHERE f4.wra_fu_conf_consent_f4 IN (0, 1)
          GROUP BY v5.visit_number, v5.visit_date, v5.screening_id
          ORDER BY v5.visit_date DESC),
     wra_fu_5_consent AS
         (SELECT v6.*,
                 IF(f5.wra_fu_conf_consent_f5 = 1, 'Yes',
                    IF(f5.wra_fu_conf_consent_f5 = 0, 'No', f5.wra_fu_conf_consent_f5)) as ongoing_consent_confirmed,
                 IF(f5.wra_fu_reas_decline_const_f5 = 4,
                    CONCAT_WS(' - ', 'Other', f5.fu_reason_decline_other_f5),
                    f5.wra_fu_reas_decline_const_f5_label)                              as consent_declined_reason
          FROM crt_wra_visit_6_overview v6
                   LEFT JOIN wra_follow_up_visit_5_repeating_instruments f5
                             ON v6.alternate_id = f5.wra_follow_up_visit_5_repeating_instruments_id
          WHERE f5.wra_fu_conf_consent_f5 IN (0, 1)
          GROUP BY v6.visit_number, v6.visit_date, v6.screening_id
          ORDER BY v6.visit_date DESC)
        (SELECT * FROM wra_fu_1_consent)
UNION
(SELECT * FROM wra_fu_2_consent)
UNION
(SELECT * FROM wra_fu_3_consent)
UNION
(SELECT * FROM wra_fu_4_consent)
UNION
(SELECT * FROM wra_fu_5_consent);
