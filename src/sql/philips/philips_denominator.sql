  --------------------------
  --- Counts of patients in Philips ISBM dataset ---
  --------------------------------------------------
  
   SELECT COUNT(DISTINCT stanford_patient_uid) AS counts_pts,  count(distinct accession_number) as n_acc,
    'Philips ISBM' AS data_set 
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON p.person_source_value = phi.stanford_patient_uid