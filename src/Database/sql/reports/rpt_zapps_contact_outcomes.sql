SELECT zr.*,
       (CASE
            WHEN ct.contact_outcome IS NULL THEN 'Not Contacted'
            WHEN ct.contact_outcome IS NOT NULL THEN ct.contact_outcome
           END)        AS zapps_contact_outcome,
       ct.contact_count,
       ct.contact_date as zapps_contact_date,
       ct.new_appointment_date
FROM vw_wra_zapps_referrals zr
         LEFT JOIN vw_zapps_contact_tracker ct ON zr.wra_ptid = ct.wra_ptid;