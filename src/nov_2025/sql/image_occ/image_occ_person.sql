
--------------------------------------------------------
--- number of unique series and number of unique pts ---
--------------------------------------------------------

SELECT COUNT(*) AS counts, 'Number of series in image_occurrence table' AS variable_name
FROM (
    SELECT DISTINCT image_study_uid, image_series_uid
    FROM `@oncology_omop.image_occurrence`
) AS distinct_series

UNION ALL

SELECT COUNT(DISTINCT person_id) AS counts, 'Number of unique persons in image_occurrence table' AS variable_name
FROM `@oncology_omop.image_occurrence`