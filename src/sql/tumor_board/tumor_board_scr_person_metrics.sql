---------------------------------------------
--- number of arpha pts with tb and registry 
----------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_temp_dev.@oncology_temp_data.onc_all__cancer_flags`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes`),
scr_patients as (
    select distinct stanford_patient_uid from scr
    WHERE trim(medicalRecordNumber) <> '' and length(scr.dateOfBirth) = 8
),
tumor_board_patients AS (
SELECT
 person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join scr_patients on person.person_source_value = scr_patients.stanford_patient_uid