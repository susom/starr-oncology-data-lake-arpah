-----------------------------------------------------------------------------------------------------------
--- Number of patients diagnosed with thoracic cancer and have a tumor board encounter with a death date
---------------------------------------------------------------------------------------------------------
with
scr as (select * from `@oncology_dev.@oncology_common.onc_neuralframe_case_diagnoses`),
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_dev.@oncology_temp.onc_all__cancer_flags`),
death_src as (select distinct person_source_value from all_flag where scr_death_date is not null
or death_datetime is not null),
tumor_board_patients AS (
select person_source_value from all_flag
where tumor_board_encounter_flag = 1
),
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
inner join tumor_board_patients tb on person.person_source_value =tb.person_source_value
inner join death_src on person.person_source_value=death_src.person_source_value
