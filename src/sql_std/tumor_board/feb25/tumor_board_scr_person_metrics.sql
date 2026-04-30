---------------------------------------------
--- number of arpha pts with tb and registry 
----------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes`),
scr_patients as (
    select distinct person_id from scr
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
inner join person on person.person_id = tb.person_id
inner join scr_patients on person.person_id = scr_patients.person_id