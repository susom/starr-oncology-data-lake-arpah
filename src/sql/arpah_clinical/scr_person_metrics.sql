with
scr as (select * from `som-rit-phi-oncology-prod.oncology_neuralframe_raw.neuralframe_parquet_registry_data`),
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr_patients as (
    select distinct
    cast(scr.dateOfBirth as date format 'yyyymmdd') as dateOfBirth,
      IF(LENGTH(medicalRecordNumber) <= 8, LPAD(medicalRecordNumber, 8, '0'), LPAD(medicalRecordNumber, 10, '0')) as cleaned_mrn --handle 8 digit or 10 digit mrns
    FROM scr
    WHERE trim(medicalRecordNumber) <> '' and length(scr.dateOfBirth) = 8
)
select
count(distinct person.person_source_value) patient_count
  from
  scr_patients
 inner join person on person.person_source_value = concat(cleaned_mrn, ' | ', dateOfBirth)
