with
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
pat_enc as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.pat_enc`),
zc_disp_enc_type as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.zc_disp_enc_type`),
clarity_prc as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.clarity_prc`),
patient as (select * from `som-rit-phi-starr-prod.shc_clarity_filtered_latest.patient`),
concept as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept`),
concept_ancestor as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_ancestor`),
drug_era as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.drug_era`),
chemo_med as
(
  select distinct c.*
    from concept c
    join concept_ancestor ca on c.concept_id = ca.descendant_concept_id
    and ca.ancestor_concept_id in (21601386,724009)
    and c.invalid_reason is null
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
inner join drug_era on person.person_id = drug_era.person_id
inner join chemo_med on chemo_med.concept_id = drug_era.drug_concept_id
