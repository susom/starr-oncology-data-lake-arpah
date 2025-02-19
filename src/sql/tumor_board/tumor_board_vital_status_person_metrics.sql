----------------------------------------------------------------
-- Present Hospital or Stanford Cancer Registry death date
-----------------------------------------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology-dev.@oncology_temp.onc_all__cancer_flags`),
scr as (select * from `@oncology-dev.@oncology_common.onc_neuralframe_case_outcomes`),
death as (select * from `@oncology_prod.@oncology_omop.death`),
death_src as (select distinct person_source_value from all_flag where scr_death_date is not null or death_datetime is not null),
scr_patients as (
    select distinct stanford_patient_uid from scr
),
tumor_board_patients AS (
select distinct person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
left join death on person.person_id = death.person_id
left join scr_patients on person.person_source_value = scr_patients.stanford_patient_uid
left join death_src on person.person_source_value=death_src.person_source_value
where
death_src.person_source_value is not null
or death.death_date is not null
