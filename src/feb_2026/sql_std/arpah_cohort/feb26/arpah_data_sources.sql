---------------------------------------------------------------
--- Count unique person_ids from different datasets
---------------------------------------------------------------

SELECT 'Oncology OMOP' AS data_set, COUNT(DISTINCT person_id) AS unique_patients
FROM `@oncology_prod.@oncology_omop.person`

UNION ALL 

SELECT 'Image Occurrence' AS data_set, COUNT(DISTINCT person_id) AS unique_patients
FROM `@oncology_prod.@oncology_omop.image_occurrence`

UNION ALL

SELECT 'Neural Frame' AS data_set, COUNT(DISTINCT p.person_id) AS unique_patients
FROM `@oncology_prod.@oncology_omop.person` p
INNER JOIN `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes` nf
ON JSON_VALUE(p.person_source_value, '$.stanford_patient_uid') = nf.stanford_patient_uid

UNION ALL 

SELECT 'Philips ISPM' AS data_set, COUNT(DISTINCT p.person_id) AS unique_patients
FROM `@oncology_prod.@oncology_omop.person` p
INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
ON JSON_VALUE(p.person_source_value, '$.stanford_patient_uid') = phi.stanford_patient_uid

UNION ALL

SELECT 'Tumor Board' AS data_set, COUNT(DISTINCT person_id) AS unique_patients
FROM `@oncology_prod.@oncology_omop.visit_occurrence`
WHERE LOWER(visit_source_value) LIKE '%tumor board%'

ORDER BY unique_patients DESC
