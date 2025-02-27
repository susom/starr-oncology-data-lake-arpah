
----------------------
--- cancer status 
------------------------
with nf as (
select scr.*  from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person` p
inner join som-rit-phi-oncology-prod.oncology_neuralframe_arpah_alpha.onc_neuralframe_case_outcomes scr
on p.person_source_value = concat(scr.cleaned_nf_mrn, ' | ', scr.cleaned_nf_dob)
) select vitalstatusdescription, count(*) from nf 
group by 1
order by 2 desc