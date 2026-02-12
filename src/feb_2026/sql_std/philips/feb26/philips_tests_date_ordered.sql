  -------------------------------------------------
  ---  Date ranges for test types ordered
  --------------------------------------------------
  
   with all_philips as (
    select phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON json_value(p.person_source_value, '$.stanford_patient_uid') = phi.stanford_patient_uid
   )
    select test_type, 
            min(date_of_test) as min_order_date,
            max(date_of_test) as max_order_date
      FROM all_philips group by test_type