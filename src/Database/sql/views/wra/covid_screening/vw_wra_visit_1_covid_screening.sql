/**
 * WRA Mortality Outcome Overview; Coded as [Alive] or [Deceased].
 * @dataSource WRA SAE CRT [crt_wra_adverse_events]
 * @author Gift Jr <muyembegift@gmail.com> | 04.03.25
 * @since 0.0.1
 * @alias WRA Mortality
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_mortality_overview
AS
WITH wra_mortality AS (SELECT sae.record_id,
                              sae.screening_id,
                              sae.wra_ptid,
                              sae.age,
                              sae.visit_number,
                              sae.visit_name,
                              sae.visit_date,
                                sae.outcome_of_sae as outcome
                       FROM crt_wra_adverse_events sae)
        (SELECT * FROM wra_mortality);
