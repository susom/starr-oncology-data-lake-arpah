-------------------------------------------------------------------------
-- this query generates tb patients case status
------------------------------------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
tb_visits as (select * from `@oncology_prod.@oncology_omop.visit_occurrence`),
scr_thoracic_patients as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
WHERE
(lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
),
tumor_board_patients AS (
      select person_id from tb_visits
    where  LOWER(visit_source_value) LIKE '%tumor board%'
),
case_status_category as
(select
person.person_id,
case
when scr_thoracic_patients.nfcasestatus in ('Incomplete','Incomplete - Edit','Suspense') then 'Incomplete'
else nfcasestatus
end nfcasestatus_category
from
tumor_board_patients tb
inner join person on person.person_id = tb.person_id
inner join scr_thoracic_patients on person.person_id = scr_thoracic_patients.person_id
),
unique_pat as
(select distinct person_id from case_status_category),
complete_pat as
(select * from case_status_category
where nfcasestatus_category = 'Completed'
),
incomplete_pat as
(select * from case_status_category
where nfcasestatus_category = 'Incomplete'
),
notreportable_pat as
(select * from case_status_category
where nfcasestatus_category = 'Not Reportable'
),
derived as
(select
distinct
unique_pat.*
,case
when complete_pat.person_id is not null then 'Complete'
when complete_pat.person_id is null and incomplete_pat.person_id is null and notreportable_pat.person_id is not null then 'Not Reportable'
else 'Incomplete'
end patient_status
from
unique_pat
left join complete_pat on unique_pat.person_id = complete_pat.person_id
left join incomplete_pat on unique_pat.person_id = incomplete_pat.person_id
left join notreportable_pat on unique_pat.person_id = notreportable_pat.person_id
)
select patient_status,count(1) from derived
group by patient_status order by 2 desc
