with
person as (select * from `@oncology_prod.@oncology_omop.person`),
shc_pathology as (select * from `@starr_prod.@starr_common.shc_pathology`),
patient as (select * from `@starr_prod.@shc_clarity.patient`),
powerpath_beaker_path_patients as (
select
distinct
p.pat_mrn_id,
p.birth_date
from
shc_pathology sp
join patient p on p.pat_id = sp.pat_id 
where
sp.report_source ='PowerPath'
or (sp.report_source = 'Beaker AP'
and sp.order_type = 'Pathology')
)
select
  count(distinct person.person_source_value) patient_count
  from
  powerpath_beaker_path_patients p
inner join person on person.person_source_value = CONCAT(FORMAT('%s | %s', p.pat_mrn_id, CAST(cast(p.birth_date AS date) AS string format 'yyyy-mm-dd')))
