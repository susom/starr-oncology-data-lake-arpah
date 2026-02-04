  --------------------------------------------------------------------
  --- Counts of thoracic patients in Philips ISPM dataset ---
  --------------------------------------------------------------------
with thoracic_pts as (
select distinct p.person_id , nf.stanford_patient_uid 
from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` nf 
INNER JOIN `@oncology_prod.@oncology_omop.person` p 
ON p.person_source_value = nf.stanford_patient_uid
where LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
) , 
with_abr as (
select count(distinct(abr.stanford_patient_uid)) as n_pts, 'abr' as flag 
from  `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(stanford_patient_uid)
),
with_test as (
  select count(distinct(diag.stanford_patient_uid)), 'total' as flag
from `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` diag
inner join thoracic_pts using(stanford_patient_uid)
)
select * from with_abr union all select * from with_test