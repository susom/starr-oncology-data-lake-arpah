with
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
aria_patient as (select * from `som-rit-phi-oncology-prod.oncology_aria_raw.patient`),
aria_patients as
(
  select
  distinct
  patientid,
  extract(date from dateofbirth) dateofbirth
  from
  aria_patient
)
select
distinct
count(distinct p.person_source_value) patient_count
  from aria_patients ap
  join person p on concat(FORMAT('%s | %s', ap.patientid,
  cast(ap.dateofbirth as string format 'yyyy-mm-dd'))) = p.person_source_value