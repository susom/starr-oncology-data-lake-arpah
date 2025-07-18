-------------------------------
--- number of tb patients 
-------------------------------

with
tb_visits as (select * from  `@oncology_prod.@oncology_omop.visit_occurrence`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
tumor_board_patients AS (
    select person_id from tb_visits
    where  LOWER(visit_source_value) LIKE '%tumor board%'
),
scr_thoracic_patients as (
    select distinct
person_id
    FROM scr
    where lower(primarysiteDescription) like '%lung%'
    or lower(primarysiteDescription) like '%bronchus%'
    or lower(primarysiteDescription) like '%thymus%'
)
select count(distinct person.person_id) patient_count
from
tumor_board_patients tb
inner join person on person.person_id = tb.person_id
inner join scr_thoracic_patients on person.person_id = scr_thoracic_patients.person_id
