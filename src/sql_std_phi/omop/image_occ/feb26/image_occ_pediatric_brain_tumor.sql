-- cohort_sql_file supplies one row per pediatric brain tumor patient.
, distinct_series AS (
  SELECT DISTINCT
    i.person_id, i.image_study_uid, i.image_series_uid, category.*
  FROM `@oncology_prod.@oncology_omop.image_occurrence` AS i
  INNER JOIN cohort USING (person_id)
  CROSS JOIN UNNEST([
    STRUCT('Modality' AS dimension, JSON_VALUE(i.modality_source_value, '$.modality') AS data_source),
    STRUCT('Anatomic site', JSON_VALUE(i.anatomic_site_source_value, '$.body_part_examined'))
  ]) AS category
  WHERE NULLIF(TRIM(category.data_source), '') IS NOT NULL
    AND LOWER(category.data_source) != 'null'
    AND NOT (category.dimension = 'Modality' AND category.data_source IN ('PR', 'KO', 'REG', 'SR'))
)
SELECT
  dimension, data_source,
  COUNT(DISTINCT person_id) AS patient_count,
  COUNT(*) AS record_count,
  ROUND(100 * SAFE_DIVIDE(COUNT(DISTINCT person_id), (SELECT COUNT(*) FROM cohort)), 1) AS percentage
FROM distinct_series
GROUP BY dimension, data_source
ORDER BY dimension, patient_count DESC, data_source
