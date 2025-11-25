
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
death as (select person_id from `@oncology_prod.@oncology_omop.death` where death_date is not null),
death_src as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes`
 where vitalstatusdescription = 'Dead'
), 
all_death as (
select person.*,
case when death.person_id is not null then 1 else 0 end as death_flag,
from
person 
left join death_src on person.person_source_value = death_src.stanford_patient_uid
left join death on person.person_id = death.person_id
where
  death_src.stanford_patient_uid is not null  -- Has death record in NeuralFrame
  or death.person_id is not null )
  select count(distinct person_id) as n_death from all_death where death_flag=1            
