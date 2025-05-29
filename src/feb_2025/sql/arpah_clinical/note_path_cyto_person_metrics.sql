with
person as (select * from `@oncology_prod.@oncology_omop.person`),
note as (select * from `@oncology_prod.@oncology_omop.note`)
select
count(distinct person.person_source_value) patient_count
from
note
join person on note.person_id = person.person_id
where
note_title in ('pathology','pathology and cytology')