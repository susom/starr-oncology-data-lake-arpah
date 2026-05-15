--------------------------------------------------------------------------
-- Patient summary by diagnosis year in Neural Frame 
-- 'completed' case status and diagnosed with thoracic cancer 
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_data as
(
select
distinct nf.person_id,
primarySiteDescription,nfcasestatus
,MIN(dateOfDiagnosis) as earliest_scr_diagnosis_date --note: not all patients have a SCR diagnosis date
from
scr nf
group by nf.person_id,primarySiteDescription,nfcasestatus
),
scr_omop as
(select
 distinct
 p.person_id,
 p.person_source_value,
 primarySiteDescription,
 nfcasestatus,
 scr_data.earliest_scr_diagnosis_date
from
scr_data
inner join person p on p.person_id = scr_data.person_id
)
select
substr(earliest_scr_diagnosis_date,1,4) dx_year,
count(distinct s.person_id) patient_count
from scr_omop s
where
nfcasestatus = 'Completed'
and (
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
group by dx_year
order by dx_year desc