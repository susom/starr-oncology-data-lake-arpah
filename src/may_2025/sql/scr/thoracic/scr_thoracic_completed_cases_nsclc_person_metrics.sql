--------------------------------------------------------------------------
-- Patient summary by diagnosis year in Neural Frame 
-- 'completed' case status and diagnosed with thoracic cancer 
-- NSCLC - non-small cell - histologicTypeIcdO3 = '8046'
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct stanford_patient_uid,
primarySiteDescription,nfcasestatus,histologicTypeIcdO3
,MIN(dateOfDiagnosis) as earliest_scr_diagnosis_date --note: not all patients have a SCR diagnosis date
from
scr nf
group by stanford_patient_uid ,primarySiteDescription,nfcasestatus,histologicTypeIcdO3
),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 nfcasestatus,
 histologicTypeIcdO3,
 scr_data.earliest_scr_diagnosis_date
from
scr_data
inner join person p on p.person_source_value = scr_data.stanford_patient_uid
)
select
count(distinct person_source_value) patient_count
from scr_omop
where
nfcasestatus = 'Completed'
and histologicTypeIcdO3 = '8046'
and (
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
