
--------------------------------------------------------------------------
-- Number of thoracic cancer with smoking and alcohol history
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_misc_details` ),
dx as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
where
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
),
scr_data as
(select scr.* from scr
inner join person p on p.person_source_value = scr.stanford_patient_uid
inner join dx on scr.stanford_patient_uid=dx.stanford_patient_uid
),
smk_stat as (select naaccrtobaccodescription, count(distinct(stanford_patient_uid)) as counts, 'smoking status' as flag
from scr_data
group by 1
order by 1),
alc_stat as (select naaccralcoholdescription, count(distinct(stanford_patient_uid)) as counts, 'alcohol status' as flag
from scr_data
group by 1
order by 1)
select * from smk_stat union all select * from alc_stat
