-- Coverage summary for the pediatric brain tumor cohort.
WITH tumor_conditions AS (
  SELECT
    co.person_id,
    co.condition_occurrence_id,
    co.condition_concept_id,
    co.condition_start_date
  FROM `@oncology_prod.@oncology_omop.condition_occurrence` AS co
  WHERE co.condition_concept_id IN (
    SELECT descendant_concept_id
    FROM `@oncology_prod.@oncology_omop.concept_ancestor`
    WHERE ancestor_concept_id IN (
      373724,
      4239871,
      4247822,
      36558882
    )
  )
),

dx_with_age AS (
  SELECT
    tc.*,
    DATE_DIFF(
      tc.condition_start_date,
      DATE(p.birth_datetime),
      YEAR
    ) - IF(
      FORMAT_DATE('%m%d', tc.condition_start_date)
        < FORMAT_DATE('%m%d', DATE(p.birth_datetime)),
      1,
      0
    ) AS age_at_diagnosis
  FROM tumor_conditions AS tc
  INNER JOIN `@oncology_prod.@oncology_omop.person` AS p
    USING (person_id)
  WHERE
    p.birth_datetime IS NOT NULL
    AND tc.condition_start_date IS NOT NULL
),

first_dx AS (
  SELECT *
  FROM dx_with_age
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY person_id
    ORDER BY condition_start_date, condition_occurrence_id
  ) = 1
),

cohort AS (
  SELECT person_id
  FROM first_dx
  WHERE age_at_diagnosis BETWEEN 0 AND 18
),

cohort_size AS (
  SELECT COUNT(*) AS patient_total
  FROM cohort
),

genomic_tests AS (
  SELECT
    'Genomic Testing' AS coverage_type,
    COALESCE(v.test_name, 'Unknown or missing') AS data_source,
    COUNT(DISTINCT c.person_id) AS patient_count,
    COUNT(DISTINCT v.procedure_occurrence_id) AS record_count
  FROM cohort AS c
  INNER JOIN `@oncology_prod.@oncology_omop._variant_occurrence` AS v
    USING (person_id)
  GROUP BY v.test_name
),

imaging_modalities AS (
  SELECT
    'Imaging Modality' AS coverage_type,
    COALESCE(
      JSON_VALUE(SAFE.PARSE_JSON(v.modality_source_value), '$.modality'),
      v.modality_source_value,
      'Unknown or missing'
    ) AS data_source,
    COUNT(DISTINCT c.person_id) AS patient_count,
    COUNT(DISTINCT v.image_occurrence_id) AS record_count
  FROM cohort AS c
  INNER JOIN `@oncology_prod.@oncology_omop.image_occurrence` AS v
    USING (person_id)
  GROUP BY data_source
),

note_availability AS (
  SELECT
    'Clinical Notes' AS coverage_type,
    'Radiology notes' AS data_source,
    COUNT(DISTINCT c.person_id) AS patient_count,
    COUNT(DISTINCT v.note_id) AS record_count
  FROM cohort AS c
  INNER JOIN `@oncology_prod.@oncology_omop.note` AS v
    USING (person_id)
  WHERE LOWER(v.note_source_value) LIKE '%radiology%'

  UNION ALL

  SELECT
    'Clinical Notes' AS coverage_type,
    'Pathology notes' AS data_source,
    COUNT(DISTINCT c.person_id) AS patient_count,
    COUNT(DISTINCT v.note_id) AS record_count
  FROM cohort AS c
  INNER JOIN `@oncology_prod.@oncology_omop.note` AS v
    USING (person_id)
  WHERE LOWER(v.note_source_value) LIKE '%pathology%'
),

coverage AS (
  SELECT * FROM genomic_tests
  UNION ALL
  SELECT * FROM imaging_modalities
  UNION ALL
  SELECT * FROM note_availability
)

SELECT
  coverage_type,
  data_source,
  patient_count,
  record_count,
  ROUND(
    SAFE_DIVIDE(patient_count, cohort_size.patient_total) * 100,
    1
  ) AS percentage
FROM coverage
CROSS JOIN cohort_size
ORDER BY
  CASE coverage_type
    WHEN 'Genomic Testing' THEN 1
    WHEN 'Imaging Modality' THEN 2
    WHEN 'Clinical Notes' THEN 3
  END,
  patient_count DESC,
  data_source;
