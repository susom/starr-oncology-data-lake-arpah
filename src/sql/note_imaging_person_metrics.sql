with
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
note as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.note`)
select
count(distinct person.person_source_value) patient_count
from
note
join person on note.person_id = person.person_id
where
note_title in ('imaging')
