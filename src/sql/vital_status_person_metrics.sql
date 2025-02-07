with
scr as (select * from `som-rit-phi-oncology-prod.oncology_neuralframe_raw.neuralframe_parquet_registry_data`),
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
death as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.death`),
scr_patients as (
    select distinct
    cast(scr.dateOfBirth as date format 'yyyymmdd') as dateOfBirth,
      IF(LENGTH(medicalRecordNumber) <= 8, LPAD(medicalRecordNumber, 8, '0'), LPAD(medicalRecordNumber, 10, '0')) as cleaned_mrn,  --handle 8 digit or 10 digit mrns
      MAX( --get the latest-in-calendar-time calculated death date per patient
        if(trim(scr.vitalStatusDescription) = 'Dead', --if Vital Status of patient is 'Dead', use dateOfLastContact to represent death date
      cast(
        case
          when length(trim(scr.dateOfLastContact)) = 8 --if complete date, use as-is
          then scr.dateOfLastContact
          when length(trim(scr.dateOfLastContact)) = 4 -- if only have year, set month & day to 12-31
          then concat(substr(scr.dateOfLastContact,1,4),'1231')
          when trim(substr(scr.dateOfLastContact,5,2)) = '' and trim(substr(scr.dateOfLastContact,7,2)) <> ''
          then concat(substr(scr.dateOfLastContact,1,4), '12',substr(scr.dateOfLastContact,7,2))
          when trim(substr(scr.dateOfLastContact,5,2)) <> '' and trim(substr(scr.dateOfLastContact,7,2)) = ''
          then concat(substr(scr.dateOfLastContact,1,6) || '28')
        end
      as date format 'yyyymmdd'),
      NULL) --set to null if patient's vital status is not 'Dead'
      ) as scr_calc_death_date
    FROM scr
    WHERE trim(medicalRecordNumber) <> '' and length(scr.dateOfBirth) = 8
    GROUP BY cleaned_mrn, dateOfBirth --return results at patient level
)
select
count(distinct person.person_source_value) patient_count
  from
  person 
 left join death on person.person_id = death.person_id
 left join scr_patients on person.person_source_value = concat(cleaned_mrn, ' | ', dateOfBirth)
 where 
 scr_patients.scr_calc_death_date is not null
 or death.death_date is not null
