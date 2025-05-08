  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISBM dataset ---
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_dev.@oncology_philips.onc_philips_mtb_aberrations` phi
    ON p.person_source_value = phi.stanford_patient_uid
  )
    select hgnc_gene, count(distinct (stanford_patient_uid)) as n_pts
    from philips
where hgnc_gene is not null 
group by 1
order by 2 desc;