-------------------------------
--- number of tb patients 
-------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
tumor_board_patients AS (
    select person_id from all_flag
    where tumor_board_encounter_flag = 1
)
select count(distinct person.person_id) patient_count
from
tumor_board_patients tb
inner join person on person.person_id = tb.person_id
