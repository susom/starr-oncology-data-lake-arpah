
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
and nfcasestatus="Completed" ),
scr_data as
(select scr.* from scr
inner join person p on p.person_source_value = concat(scr.cleaned_nf_mrn, ' | ', scr.cleaned_nf_dob)
inner join dx on concat(scr.cleaned_nf_mrn, ' | ', scr.cleaned_nf_dob)=concat(dx.cleaned_nf_mrn, ' | ', dx.cleaned_nf_dob)
),
smk_stat as (select naaccrtobaccodescription, count(*) as counts, 'smoking status' as flag
from scr_data
where naaccrtobaccodescription is not null
group by 1
order by 1),
alc_stat as (select naaccralcoholdescription, count(*) as counts, 'alcohol status' as flag
from scr_data
where naaccralcoholdescription is not null
group by 1
order by 1)
select * from smk_stat union all select * from alc_stat
