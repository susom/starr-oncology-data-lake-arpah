-------------------------------
--- number of tb patients 
-------------------------------

with
tb_visits as (select * from `@oncology_prod.@oncology_omop.visit_occurrence`),
tumor_board_patients AS (
    select person_id from tb_visits
    where  LOWER(visit_source_value) LIKE '%tumor board%'
)
select count(distinct person_id) patient_count
from
tumor_board_patients tb

