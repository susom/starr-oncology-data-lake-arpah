  -------------------------------------------------
  --- Number of Tests Ordered by Test Type
  --------------------------------------------------
  
   SELECT test_type, count(*) AS test_type_counts
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON p.person_id = phi.person_id
    group by 1