--------------------------------------------------------------------------
-- Patient summary by histology in Neural Frame 
-- 'completed' case status and diagnosed with thoracic cancer 
---------------------------------------------------------------------------

with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct nf.person_id,
primarySiteDescription,nfcasestatus,histologicTypeIcdO3,histologicTypeIcdO3Description
,MIN(dateOfDiagnosis) as earliest_scr_diagnosis_date --note: not all patients have a SCR diagnosis date
from
scr nf
group by nf.person_id,primarySiteDescription,nfcasestatus,histologicTypeIcdO3,histologicTypeIcdO3Description
),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 nfcasestatus,
 histologicTypeIcdO3,
 histologicTypeIcdO3Description,
 scr_data.earliest_scr_diagnosis_date
from
scr_data
inner join person p on p.person_id = scr_data.person_id
)
select
histologicTypeIcdO3Description,
histologicTypeIcdO3,
count(distinct s.person_id) patient_count
from scr_omop s
where
nfcasestatus = 'Completed'
and (
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
group by histologicTypeIcdO3,histologicTypeIcdO3Description
;
