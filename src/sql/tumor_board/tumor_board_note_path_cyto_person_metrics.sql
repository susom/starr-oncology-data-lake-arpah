--------------------------------------------------------------------------
-- this query generates tb patients who had pathology from arpah-cohort --
--------------------------------------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_temp_dev.@oncology_temp_data.onc_all__cancer_flags`),
note as (select * from `@oncology_prod.@oncology_omop.note`),
tumor_board_patients 
AS ( select person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join note on note.person_id = person.person_id
where
note_title in ('pathology','pathology and cytology')