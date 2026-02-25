with
person as (select * from `@oncology_prod.@oncology_omop.person`),
note as (select * from `@oncology_prod.@oncology_omop.note`)
select
count(distinct person.person_source_value) as patient_count,
count(distinct note.note_id) as number_of_note_count
from
note
join person on note.person_id = person.person_id



