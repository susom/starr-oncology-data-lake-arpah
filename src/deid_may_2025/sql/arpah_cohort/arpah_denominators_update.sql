
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
    
    UNION ALL
    
    SELECT COUNT(DISTINCT p.person_id) AS counts_pts, 'Neural Frame' AS data_set 
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes` nf
    ON p.person_id = nf.person_id
    
    UNION ALL 
    
    SELECT COUNT(DISTINCT p.person_id) AS counts_pts, 'Philips ISPM' AS data_set 
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders`  phi
    ON p.person_id = phi.person_id

    UNION ALL
    SELECT COUNT(DISTINCT person_id) AS counts_pts, 'With Tumor Board Encounter' AS data_set
    FROM `@oncology_prod.@oncology_omop.visit_occurrence` 
    WHERE  LOWER(visit_source_value) LIKE '%tumor board%'
) AS counts 
