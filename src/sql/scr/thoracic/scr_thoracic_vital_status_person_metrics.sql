---------------------------------------------------------------------------------------------
-- Number of patients in Neural Frame and diagnosed with thoracic cancer with a death date 
----------------------------------------------------------------------------------------------
with
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
person as (select * from `@oncology_prod.@oncology_omop.person`),
death as (select * from `@oncology_prod.@oncology_omop.death`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
death_src as (select distinct person_source_value from all_flag where scr_death_date is not null
or death_datetime is not null),
scr_thoracic_patients as (
    select distinct
cleaned_nf_mrn,cleaned_nf_dob
    FROM scr
    WHERE trim(medicalRecordNumber) <> '' and length(dateOfBirth) = 8
    and lower(primarysiteDescription) like '%lung%'
    or lower(primarysiteDescription) like '%bronchus%'
    or lower(primarysiteDescription) like '%thymus%'
    GROUP BY cleaned_nf_mrn, cleaned_nf_dob --return results at patient level
)
select
count(distinct person.person_source_value) patient_count
  from
  person
inner join scr_thoracic_patients on person.person_source_value = concat(scr_thoracic_patients.cleaned_nf_mrn, ' | ', scr_thoracic_patients.cleaned_nf_dob)
left join death_src on person.person_source_value=death_src.person_source_value
left join death on person.person_id = death.person_id
where
death_src.person_source_value is not null
or death.death_date is not null