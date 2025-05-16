  --------------------------------------------------------------------
  --- Counts of thoracic patients in Philips ISBM dataset ---
  --------------------------------------------------------------------
with thoracic_pts as (
select distinct p.person_id , nf.stanford_patient_uid 
from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` nf 
INNER JOIN `@oncology_prod.@oncology_omop.person` p 
ON p.person_source_value = nf.stanford_patient_uid
where LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
) 
,
coding as (
select stanford_hgvs_coding, count(distinct(stanford_patient_uid)) as n_pts, 'hgvs_coding' as flag
from `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(stanford_patient_uid)
where hgnc_gene in ("KRAS") and stanford_hgvs_coding is not null
group by 1),
protein as (
  select stanford_hgvs_protein, count(distinct(stanford_patient_uid)) as n_pts, 'hgvs_protein' as flag
from `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(stanford_patient_uid)
where hgnc_gene in ("KRAS") and stanford_hgvs_protein is not null
group by 1),
change_aa as (select stanford_aa_change, count(distinct(stanford_patient_uid)) as n_pts, 'aa_change' as flag
from `@oncology_prod.@oncology_philips.onc_philips_mtb_aberrations` abr
inner join thoracic_pts using(stanford_patient_uid)
where hgnc_gene in ("KRAS") and stanford_aa_change is not null
group by 1)
select * from coding union all select * from protein union all select * from change_aa