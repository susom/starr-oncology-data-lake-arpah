---------------------------------------------
--- number of arpha pts with tb and wsi beaker
----------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_dev.@oncology_temp.onc_all__cancer_flags`),
patient as (select * from `@starr_prod.@shc_clarity.patient`),
shc_pathology as (select * from `@starr_prod.@starr_common.shc_pathology`),
wsi_beaker_path_patients as (
select
distinct
p.pat_mrn_id,
p.birth_date
from
shc_pathology sp
join patient p on p.pat_id = sp.pat_id
where
sp.report_source = 'Beaker AP'
and sp.order_type = 'Pathology'
and sp.acc_num like 'SP%'
),
tumor_board_patients AS (
SELECT distinct
 person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join wsi_beaker_path_patients wsi on
 person.person_source_value = CONCAT(FORMAT('%s | %s', wsi.pat_mrn_id, CAST(cast(wsi.birth_date AS date) AS string format 'yyyy-mm-dd')))