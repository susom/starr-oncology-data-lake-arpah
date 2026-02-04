
----------------------
--- vital status 
------------------------
with nf as (
select scr.*  from  `@oncology_prod.@oncology_omop.person` p
inner join `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes` scr
on  json_value (p.person_source_value, '$.stanford_patient_uid') = scr.stanford_patient_uid
) select vitalstatusdescription, COUNT(DISTINCT stanford_patient_uid) as n_pts from nf 
group by 1
order by 2 desc

