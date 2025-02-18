with 
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
scr as (select * from `som-rit-phi-oncology-prod.oncology_neuralframe_raw.neuralframe_parquet_registry_data`),
scr_data as
(
select
distinct
IF(LENGTH(medicalRecordNumber) <= 8, LPAD(medicalRecordNumber, 8, '0'), LPAD(medicalRecordNumber, 10, '0')) as cleaned_mrn
,cast(dateOfBirth as date format 'yyyymmdd') as dateOfBirth
,primarySiteDescription
,MIN(dateOfDiagnosis) as earliest_scr_diagnosis_date --note: not all patients have a SCR diagnosis date
from
scr nf
where
trim(medicalRecordNumber) <> ''and length(dateOfBirth) = 8
group by cleaned_mrn,dateOfBirth,primarySiteDescription
),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 scr_data.earliest_scr_diagnosis_date
from
scr_data
join person p on p.person_source_value = CONCAT(scr_data.cleaned_mrn, ' | ', scr_data.dateOfBirth)
)
select
count(distinct person_source_value) patient_count
from scr_omop
where
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'

-- number of lung cancer -- 
-- Number of patients in Neural Frame and diagnosed with thoracic cancer (B)