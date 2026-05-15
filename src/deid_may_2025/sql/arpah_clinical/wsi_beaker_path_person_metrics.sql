with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`)
select count(distinct person.person_id) patient_count from all_flag 
inner join person on person.person_id = all_flag.person_id
where  (pts_pathology_flag=1)