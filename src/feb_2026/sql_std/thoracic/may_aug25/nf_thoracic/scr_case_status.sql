--------------------------------------------------------------------------
-- Number of cases by nfcasestatus (Completed, Not Reportable,Other)
---------------------------------------------------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`)
select nfcasestatus 
, count(distinct p.person_id) as unique_person_count_case from scr
inner join person p on p.person_source_value = scr.stanford_patient_uid
group by 1 
order by 2 desc
