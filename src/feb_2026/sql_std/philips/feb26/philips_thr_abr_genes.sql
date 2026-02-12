  --------------------------------------------------------------------
  --- Counts of thoracic patients in Philips ISPM dataset ---
  --------------------------------------------------------------------
with thoracic_pts as (
select distinct p.person_id , nf.stanford_patient_uid 
from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` nf 
INNER JOIN `@oncology_prod.@oncology_omop.person` p 
ON json_value(p.person_source_value, '$.stanford_patient_uid') = nf.stanford_patient_uid
where LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
) 
select stanford_pathogenicity, hgnc_gene, count(distinct (abr.stanford_patient_uid)) as n_pts
from `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(stanford_patient_uid)
group by 1, 2
order by 3 desc;