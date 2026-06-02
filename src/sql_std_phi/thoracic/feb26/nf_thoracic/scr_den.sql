--------------------------------------------------------------------------
-- NF SCR Denominator
---------------------------------------------------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`)
select count(distinct p.person_id) as unique_person_count from scr
inner join person p on json_value(p.person_source_value, '$.stanford_patient_uid') = scr.stanford_patient_uid
