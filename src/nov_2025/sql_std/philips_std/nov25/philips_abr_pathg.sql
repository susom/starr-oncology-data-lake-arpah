  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISPM dataset with stanford_pathogenicity-
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` phi
    ON json_value(p.person_source_value, '.$stanford_patient_uid') = phi.stanford_patient_uid
  )
    select stanford_pathogenicity, count(distinct (stanford_patient_uid)) as n_pts
    from philips
    group by 1
    order by 2 desc;
