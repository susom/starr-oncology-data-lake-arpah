  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISBM dataset ---
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` phi
    ON p.person_source_value = phi.stanford_patient_uid
  )
    select aberration_class, count(distinct (stanford_patient_uid)) as n_pts
    from philips
