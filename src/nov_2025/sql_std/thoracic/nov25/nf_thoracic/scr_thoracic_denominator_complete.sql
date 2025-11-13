
--------------------------------------------------------------------------
-- Number of thoracic cancer patients in the denominator
---------------------------------------------------------------------------

with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from  `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct stanford_patient_uid,
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
inner join person p on json_value(p.person_source_value, '$.stanford_patient_uid') = scr_data.stanford_patient_uid
where nfcasestatus ="Completed"
)
select
count(distinct person_source_value) as unique_thoracic_cancer_pts
from scr_omop
where
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
