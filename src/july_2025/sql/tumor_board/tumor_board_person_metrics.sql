-------------------------------
--- number of tb patients 
-------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
tb_visits as (select * from `@oncology_prod.@oncology_omop.visit_occurrence`),
tumor_board_patients AS (
    select person_source_value from tb_visits
    where  LOWER(visit_source_value) LIKE '%tumor board%'
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
