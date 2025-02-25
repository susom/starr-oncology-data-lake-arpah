with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_dev.@oncology_temp.onc_all__cancer_flags`),
tumor_board_patients AS (
select person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
