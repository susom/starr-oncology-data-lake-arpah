--------------------------------------------------------------------------
-- Patient summary by primary site group in Neural Frame 
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
concept as (select * from `@oncology_prod.@oncology_omop.concept`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_patients as
  (
    select
    distinct
        nf.*
        ,case
  when primarySite is not null and histologicTypeIcdO3 is not null and behaviorCodeIcdO3 is not null then
    concat(histologicTypeIcdO3,'/',behaviorCodeIcdO3,'-',concat(substr(primarySite,1,3),'.',substr(primarySite,4,1) ))
  when primarySite is not null and histologicTypeIcdO3 is null and behaviorCodeIcdO3 is null then
    concat('NULL-',concat(substr(primarySite,1,3),'.',substr(primarySite,4,1) ))
end dx_concept_code
    from
    scr nf
),
cancer_disease_group as
(
SELECT
distinct
    source.concept_code icdo3_concept_code
    ,source.concept_name icdo3_concept_name
FROM concept source
where source.vocabulary_id = 'ICDO3'
and length(source.concept_code) = 3
and source.concept_code like 'C%'
),
unique_dx_concept_codes as
(
  select
distinct
histologicTypeIcdO3,
behaviorCodeIcdO3,
primarySite,
case
  when primarySite is not null and histologicTypeIcdO3 is not null and behaviorCodeIcdO3 is not null then
    concat(histologicTypeIcdO3,'/',behaviorCodeIcdO3,'-',concat(substr(primarySite,1,3),'.',substr(primarySite,4,1) ))
  when primarySite is not null and histologicTypeIcdO3 is null and behaviorCodeIcdO3 is null then
    concat('NULL-',concat(substr(primarySite,1,3),'.',substr(primarySite,4,1) ))
end concept_code
from scr
where case
  when primarySite is not null and histologicTypeIcdO3 is not null and behaviorCodeIcdO3 is not null then
    concat(histologicTypeIcdO3,'/',behaviorCodeIcdO3,'-',concat(substr(primarySite,1,3),'.',substr(primarySite,4,1) ))
  when primarySite is not null and histologicTypeIcdO3 is null and behaviorCodeIcdO3 is null then
    concat('NULL-',concat(substr(primarySite,1,3),'.',substr(primarySite,4,1) ))
end is not null
),
dx_name as
(
  select
  distinct
  c.concept_code,
  c.concept_name
  from concept c
    join unique_dx_concept_codes dx on dx.concept_code = c.concept_code
where c.vocabulary_id = 'ICDO3' and c.domain_id = 'Condition'
),
scr_dx_omop as
(
select distinct
person.person_source_value,
scr_patients.*,
dg.icdo3_concept_code primary_site_group_code,
dg.icdo3_concept_name primary_site_group_name,
dx_name.concept_code dx_concept_code,
dx_name.concept_name dx_name
from
scr_patients
join person on person.person_source_value = CONCAT(scr_patients.cleaned_nf_mrn, ' | ', scr_patients.cleaned_nf_dob)
left join cancer_disease_group dg on substr(scr_patients.primarySite,1,3) = dg.icdo3_concept_code
left join dx_name on scr_patients.dx_concept_code = dx_name.concept_code
)
select
primary_site_group_code,
primary_site_group_name,
count(distinct person_source_value) patient_count
from scr_dx_omop
group by primary_site_group_code,primary_site_group_name
order by primary_site_group_code
