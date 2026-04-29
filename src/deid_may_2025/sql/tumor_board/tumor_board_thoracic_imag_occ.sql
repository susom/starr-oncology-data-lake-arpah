
-----------------------------------------------------------------------
--- Number of pts with thoracic cancer, tb, and image occur records
-----------------------------------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
image_occ as (select * from `@oncology_prod.@oncology_omop.image_occurrence`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
tumor_board_patients AS (
select person_id from all_flag
where tumor_board_encounter_flag = 1
),
scr_thoracic_patients as (
    select distinct person_id
    FROM scr
   where ( lower(primarysiteDescription) like '%lung%'
    or lower(primarysiteDescription) like '%bronchus%'
    or lower(primarysiteDescription) like '%thymus%')
),
person_img as (select person_id from person inner join image_occ using (person_id))
select count(distinct person_img.person_id) patient_count
from
tumor_board_patients tb
inner join person_img on person_img.person_id = tb.person_id
inner join scr_thoracic_patients on person_img.person_id = scr_thoracic_patients.person_id


