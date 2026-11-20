-- Pediatric brain tumor patient-count summary.
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

pediatric_index AS (
  SELECT *
  FROM dx_with_age
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY person_id
    ORDER BY condition_start_date, condition_occurrence_id
  ) = 1
),

pediatric_cohort AS (
  SELECT person_id
  FROM pediatric_index
  WHERE age_at_diagnosis BETWEEN 0 AND 18
),

concept_families AS (
  SELECT
    descendant_concept_id,
    ancestor_concept_id
  FROM `@oncology_prod.@oncology_omop.concept_ancestor`
  WHERE ancestor_concept_id IN (373724, 4239871, 4247822, 36558882)
),

patient_flags AS (
  SELECT
    pc.person_id,
    COUNTIF(cf.ancestor_concept_id = 373724) > 0 AS has_373724,
    COUNTIF(cf.ancestor_concept_id = 4239871) > 0 AS has_4239871,
    COUNTIF(cf.ancestor_concept_id = 4247822) > 0 AS has_4247822
  FROM pediatric_cohort AS pc
  LEFT JOIN tumor_conditions AS tc
    USING (person_id)
  LEFT JOIN concept_families AS cf
    ON tc.condition_concept_id = cf.descendant_concept_id
  GROUP BY pc.person_id
),

summary_counts AS (
  SELECT
    'Total pediatric brain tumor patients' AS metric,
    COUNT(*) AS patient_count,
    1 AS display_order
  FROM patient_flags

  UNION ALL

  SELECT
    'Neoplasm of brain (373724)' AS metric,
    COUNTIF(has_373724) AS patient_count,
    2 AS display_order
  FROM patient_flags

  UNION ALL

  SELECT
    'Benign neoplasm of central nervous system (4239871)' AS metric,
    COUNTIF(has_4239871) AS patient_count,
    3 AS display_order
  FROM patient_flags

  UNION ALL

  SELECT
    'Primary malignant neoplasm of central nervous system (4247822)' AS metric,
    COUNTIF(has_4247822) AS patient_count,
    4 AS display_order
  FROM patient_flags
)

SELECT
  metric,
  patient_count,
  ROUND(
    SAFE_DIVIDE(
      patient_count,
      (SELECT patient_count FROM summary_counts WHERE display_order = 1)
    ) * 100,
    1
  ) AS percentage,
  display_order
FROM summary_counts
ORDER BY display_order;
