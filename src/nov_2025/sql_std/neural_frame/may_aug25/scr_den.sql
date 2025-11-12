--------------------------------------------------------------------------
-- NF SCR Denominator
---------------------------------------------------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`)
select count(distinct p.person_id) as unique_person_count from scr
inner join person p on p.person_source_value = scr.stanford_patient_uid
