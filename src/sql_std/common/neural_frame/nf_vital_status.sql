
----------------------
--- vital status 
------------------------
with nf as (
select scr.*  from  `@oncology_prod.@oncology_omop.person` p
inner join `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes` scr
on p.person_id = scr.person_id
) select vitalstatusdescription, COUNT(DISTINCT person_id) as n_pts from nf 
group by 1
order by 2 desc

