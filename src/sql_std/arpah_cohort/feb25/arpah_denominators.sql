
WITH oncology_count AS (
    SELECT COUNT(DISTINCT person_id) AS counts_pts
    FROM `@oncology_prod.@oncology_omop.person`
)
SELECT 
    counts_pts, 
    data_set, 
    (counts_pts * 100.0 / (SELECT counts_pts FROM oncology_count)) AS percentage
FROM (
    SELECT COUNT(DISTINCT person_id) AS counts_pts, 'Oncology OMOP (Cohort)' AS data_set 
    FROM `@oncology_prod.@oncology_omop.person`
    
    UNION ALL 
    
    SELECT COUNT(DISTINCT person_id) AS counts_pts, 'With Image Occurrence' AS data_set 
    FROM `@oncology_prod.@oncology_omop.image_occurrence`
    
) AS counts 
