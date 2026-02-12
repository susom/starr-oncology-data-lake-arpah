  --------------------------------------------------------------------
  --- Counts of patients by site displays in Philips ISPM dataset ---
  --------------------------------------------------------------------
  with philips as (
   SELECT phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON p.person_source_value = phi.stanford_patient_uid
  )
    select site_display, site_code, count(distinct (stanford_patient_uid)) as n_pts
    from philips
where site_display is not null 
group by 1,2
order by 3 desc;