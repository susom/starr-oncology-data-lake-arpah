  --------------------------------------------------------------------
  --- Counts of thoracic patients in Philips ISPM dataset ---
  --------------------------------------------------------------------
with thoracic_pts as (
select distinct nf.person_id 
from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` nf 
INNER JOIN `@oncology_prod.@oncology_omop.person` p 
ON p.person_id = nf.person_id
where LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
) , 
with_abr as (
select count(distinct(abr.person_id)) as n_pts, 'abr' as flag 
from  `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(person_id)
),
with_test as (
  select count(distinct(diag.person_id)) as n_pts, 'total' as flag
from `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` diag
inner join thoracic_pts using(person_id)
)
select * from with_abr union all select * from with_test