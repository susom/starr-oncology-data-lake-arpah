-------------------------------------------------------------------------
-- Thoracic Cancer Tumor Board patients with Neural Frame coverage metrics
-- Shows total TB thoracic patients, those with NF data, and those with complete NF data
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
thoracic_tb_patients as (
    select distinct tb.person_id
    from tumor_board_patients tb
    inner join person on person.person_id = tb.person_id
    inner join scr_thoracic_patients scr on person.person_id = scr.person_id
),
case_status_category as (
    select
    person.person_id,
    case
    when scr_thoracic_patients.nfcasestatus in ('Incomplete','Incomplete - Edit','Suspense') then 'Incomplete'
    else nfcasestatus
    end nfcasestatus_category
    from
    thoracic_tb_patients tb
    inner join person on person.person_id = tb.person_id
    inner join scr_thoracic_patients on person.person_id = scr_thoracic_patients.person_id
),
metrics as (
    select
    'total_thoracic_tb' as metric_type,
    count(distinct person_id) as count_patients
    from thoracic_tb_patients
    
    UNION ALL
    
    select
    'thoracic_tb_with_neuralframe' as metric_type,
    count(distinct person_id) as count_patients
    from case_status_category
    
    UNION ALL
    
    select
    'thoracic_tb_neuralframe_complete' as metric_type,
    count(distinct person_id) as count_patients
    from case_status_category
    where nfcasestatus_category = 'Completed'
)
select 
metric_type,
count_patients,
round(count_patients * 100.0 / (select count_patients from metrics where metric_type = 'total_thoracic_tb'), 2) as percentage_of_total
from metrics
order by count_patients desc