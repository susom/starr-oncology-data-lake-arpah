-------------------------------
--- number of tb patients 
-------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
tumor_board_patients AS (
    select person_source_value from all_flag
    where tumor_board_encounter_flag = 1
),
scr_thoracic_patients as (
    select distinct
stanford_patient_uid
    FROM scr
    where lower(primarysiteDescription) like '%lung%'
    or lower(primarysiteDescription) like '%bronchus%'
    or lower(primarysiteDescription) like '%thymus%'
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join scr_thoracic_patients on person.person_source_value = scr_thoracic_patients.stanford_patient_uid
