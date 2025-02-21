-- how many had death date --

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_dev.@oncology_temp.onc_all__cancer_flags`),
death_src as (select distinct person_source_value from all_flag where scr_death_date is not null
or death_datetime is not null)
select
count(distinct person.person_source_value) patient_count
  from
  person 
 left join death_src on person.person_source_value=death_src.person_source_value
 where 
 death_src.person_source_value is not null