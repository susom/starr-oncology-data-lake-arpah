  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISPM dataset ---
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` phi
    ON json_value(p.person_source_value, '$.stanford_patient_uid')= phi.stanford_patient_uid
  )
    select  count(distinct (stanford_patient_uid)) as n_pts , count(distinct accession_number) as n_acc
    from philips
