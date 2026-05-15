  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISPM dataset ---
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` phi
    ON p.person_id = phi.person_id
  )
    select  chrom, hgnc_gene, count(distinct (person_id)) as n_pts
    from philips
group by 1,2
order by 3 desc;