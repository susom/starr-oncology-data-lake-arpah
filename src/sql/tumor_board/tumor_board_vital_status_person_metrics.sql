with
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
pat_enc as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.pat_enc`),
zc_disp_enc_type as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.zc_disp_enc_type`),
clarity_prc as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.clarity_prc`),
patient as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.patient`),
scr as (select * from `som-rit-phi-oncology-prod.oncology_neuralframe_raw.neuralframe_parquet_registry_data`),
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
),
tumor_board_patients AS (
SELECT
  DISTINCT p.pat_mrn_id,
  extract(date from p.birth_date) birth_date
FROM
  pat_enc enc -- this is only getting tumor board patients from shc, not lpch, is that an issue?
  left join zc_disp_enc_type et on enc.enc_type_c=et.disp_enc_type_c
  left join clarity_prc on enc.appt_prc_id = clarity_prc.prc_id
  inner join patient p on enc.pat_id=p.pat_id
  where
    (appt_status_c IS NULL OR appt_status_c = 2) --encounter is not marked as cancelled
    and (et.name IS NULL or et.name != 'Erroneous Encounter') --encounter is not labeled as erroneous
  and (
    UPPER(clarity_prc.prc_name) IN ("DISCUSSION ONLY TUMOR BOARD", "IN PERSON TUMOR BOARD", "TUMOR BOARD", "TUMOR BOARD LIVER") -- visit type (aka appt_prc_id) of tumor board
    or et.name = 'Tumor Board' --enc_type of tumor board
  )
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = CONCAT(FORMAT('%s | %s', tb.pat_mrn_id, CAST(cast(tb.birth_date AS date) AS string format 'yyyy-mm-dd')))
left join death on person.person_id = death.person_id
left join scr_patients on person.person_source_value = concat(cleaned_mrn, ' | ', dateOfBirth)
where
scr_patients.scr_calc_death_date is not null
or death.death_date is not null
