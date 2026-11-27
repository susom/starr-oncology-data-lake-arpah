-- cohort_sql_file supplies the pediatric brain tumor cohort.
SELECT
  TRIM(v.gene_name) AS data_source,
  COUNT(DISTINCT v.person_id) AS patient_count,
  COUNT(*) AS record_count,
  ROUND(100 * SAFE_DIVIDE(COUNT(DISTINCT v.person_id), (SELECT COUNT(*) FROM cohort)), 1) AS percentage
FROM `@oncology_prod.@oncology_omop._variant_occurrence` AS v
INNER JOIN cohort USING (person_id)
WHERE NULLIF(TRIM(v.gene_name), '') IS NOT NULL
GROUP BY data_source
ORDER BY patient_count DESC, data_source
LIMIT 20
