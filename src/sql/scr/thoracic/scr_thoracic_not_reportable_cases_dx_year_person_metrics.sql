--------------------------------------------------------------------------
-- Patient summary by diagnosis year in Neural Frame 
-- 'Not Reportable' case status and diagnosed with thoracic cancer 
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct cleaned_nf_mrn, cleaned_nf_dob,
primarySiteDescription,nfcasestatus
,MIN(dateOfDiagnosis) as earliest_scr_diagnosis_date --note: not all patients have a SCR diagnosis date
from
scr nf
where
trim(medicalRecordNumber) <> ''and length(dateOfBirth) = 8
group by cleaned_nf_mrn, cleaned_nf_dob,primarySiteDescription,nfcasestatus
),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 nfcasestatus,
 scr_data.earliest_scr_diagnosis_date
from
scr_data
inner join person p on p.person_source_value = concat(scr_data.cleaned_nf_mrn, ' | ', scr_data.cleaned_nf_dob)
)
select
substr(earliest_scr_diagnosis_date,1,4) dx_year,
count(distinct person_source_value) patient_count
from scr_omop
where
nfcasestatus = 'Not Reportable'
and (
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
group by dx_year
order by dx_year desc