  --------------------------------------------------------------------
  --- Counts of thoracic patients in Philips ISPM dataset ---
  --------------------------------------------------------------------
with thoracic_pts as (
select distinct p.person_id
from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` nf 
INNER JOIN `@oncology_prod.@oncology_omop.person` p 
ON p.person_id = nf.person_id
where LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
) 
select stanford_pathogenicity, hgnc_gene, count(distinct (abr.person_id)) as n_pts
from `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(person_id)
group by 1, 2
order by 3 desc;