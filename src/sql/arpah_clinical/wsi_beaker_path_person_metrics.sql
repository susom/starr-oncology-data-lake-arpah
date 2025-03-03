with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort_v2`)
select count(distinct person.person_source_value) patient_count from all_flag 
inner join person on person.person_source_value = all_flag.person_source_value
where  (pts_pathology_flag=1)