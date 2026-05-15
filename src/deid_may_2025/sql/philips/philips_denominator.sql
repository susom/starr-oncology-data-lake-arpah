  --------------------------
  --- Counts of patients in Philips ISPM dataset ---
  --------------------------------------------------
  
   SELECT COUNT(DISTINCT phi.person_id) AS counts_pts,  count(distinct accession_number) as n_acc,
    'Philips ISPM' AS data_set 
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON p.person_id = phi.person_id