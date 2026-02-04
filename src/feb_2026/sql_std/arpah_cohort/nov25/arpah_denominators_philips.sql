
WITH oncology_count AS (
    SELECT COUNT(DISTINCT person_id) AS counts_pts
    FROM `@oncology_omop.person`
)
SELECT 
    counts_pts, 
    data_set, 
    (counts_pts * 100.0 / (SELECT counts_pts FROM oncology_count)) AS percentage
FROM (
    SELECT COUNT(DISTINCT person_id) AS counts_pts, 'Oncology OMOP (Cohort)' AS data_set 
    FROM `@oncology_omop.person`
    
    UNION ALL 
    
    SELECT COUNT(DISTINCT stanford_patient_uid) AS counts_pts, 'Philips ISPM' AS data_set 
    FROM `@oncology_omop.person` p
    INNER JOIN `@oncology_philips.onc_philips_mtb_pat_diag_orders`  phi
    ON json_value(p.person_source_value, '$.stanford_patient_uid') = phi.stanford_patient_uid
   
) AS counts 
