with
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes`),
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr_patients as (
       select distinct person_id from scr
    FROM scr
    WHERE trim(medicalRecordNumber) <> '' and length(scr.dateOfBirth) = 8
)
select
count(distinct person.person_id) patient_count
  from
  scr_patients
 inner join person on person.person_id = concat(cleaned_mrn, ' | ', dateOfBirth)
