
--------------------------------------------------------------------------
-- Number of thoracic cancer patients in the denominator
---------------------------------------------------------------------------

with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from  `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct person_id,
primarySiteDescription,nfcasestatus
from scr nf),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 nfcasestatus
from
scr_data
inner join person p on p.person_id = scr_data.person_id
)
select
count(distinct s.person_id) as unique_thoracic_cancer_pts
from scr_omop s
where
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'