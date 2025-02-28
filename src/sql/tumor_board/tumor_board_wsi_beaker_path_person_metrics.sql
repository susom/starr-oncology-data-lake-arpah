---------------------------------------------
--- number of arpha pts with tb and wsi beaker
----------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_temp_dev.@oncology_temp_data.onc_all__cancer_flags`)
select count(distinct person.person_source_value) patient_count from all_flag 
inner join person on person.person_source_value = all_flag.person_source_value
where (tumor_board_encounter_flag = 1) and (pts_pathology_flag=1)