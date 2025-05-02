  -------------------------------------------------
  --- Number of Tests Ordered by Test Type
  --------------------------------------------------
  
   SELECT test_type, count(*) AS test_type_counts
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_dev.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON p.person_source_value = phi.stanford_patient_uid
    group by 1