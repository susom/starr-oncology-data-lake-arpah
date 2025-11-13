  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISPM dataset ---
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` phi
    ON json_value(p.person_source_value, '$.stanford_patient_uid') = phi.stanford_patient_uid
  )
    select hgnc_gene, count(distinct (stanford_patient_uid)) as n_pts
    from philips
where hgnc_gene is not null 
group by 1
order by 2 desc;

-- how many pts are casted or tested for each gene 