-- how many had death date --

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
death as (select * from `@oncology_prod.@oncology_omop.death`),
death_src as (select distinct person_id from all_flag where scr_death_date is not null
or death_date is not null)
select
count(distinct person.person_id) patient_count
  from
  person 
left join death_src on person.person_id=death_src.person_id
left join death on person.person_id = death.person_id
where
death_src.person_id is not null
or death.death_date is not null