--------------------------------------------------------------------------
-- Number of thoracic cancer cases by nfcasestatus (Completed, Not Reportable,Other)
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct stanford_patient_uid,
primarySiteDescription,
nfcasestatus
from
scr nf
),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 nfcasestatus
from
scr_data
inner join person p on p.person_source_value = scr_data.stanford_patient_uid
)
select
nfcasestatus,
count(distinct person_source_value) patient_count
from scr_omop
where
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
group by nfcasestatus
order by patient_count desc