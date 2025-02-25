with
person as (select * from `@oncology_prod.@oncology_omop.person`),
aria_patient as (select * from `@oncology_prod.@oncology_aria.patient`),
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