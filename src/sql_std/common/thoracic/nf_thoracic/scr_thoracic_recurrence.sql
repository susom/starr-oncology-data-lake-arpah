
-------------------------
--- recurrence stat -----
-------------------------
-- This query is used to get the recurrence status of thoracic cancer patients
WITH scr AS (
    SELECT * 
    FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
scr_data AS ( -- thoracic cancer pts 
    SELECT DISTINCT 
        person_id,
        primarySiteDescription,
        nfcasestatus
    FROM scr
    WHERE nfcasestatus="Completed" and (
        LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%')
),
scr_omop AS ( -- thoracic cancer pts in omop 
    SELECT DISTINCT
        p.person_id,
        p.person_source_value,
        sd.primarySiteDescription
    FROM scr_data sd
    INNER JOIN `@oncology_prod.@oncology_omop.person` p 
        ON p.person_id = sd.person_id
),
outcomes as (select outcome.*  from  scr_omop omop
inner join `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes` outcome
on omop.person_id = outcome.person_id
) 
select recurrenceType1st, recurrencetype1stdescription, COUNT(DISTINCT person_id) as n_pts 
from outcomes
group by 1, 2
order by 3 desc
