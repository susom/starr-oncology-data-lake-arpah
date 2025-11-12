  --------------------------
  --- Counts of patients in Philips ISPM dataset ---
  --------------------------------------------------
  
   SELECT COUNT(DISTINCT stanford_patient_uid) AS counts_pts,  count(distinct accession_number) as n_acc,
    'Philips ISPM' AS data_set 
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON json_value(p.person_source_value, '.$stanford_patient_uid') = phi.stanford_patient_uid