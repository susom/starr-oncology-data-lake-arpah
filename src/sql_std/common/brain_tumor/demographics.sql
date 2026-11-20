-- Pediatric brain tumor demographic summary.
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
    tc.person_id,
    tc.condition_occurrence_id,
    tc.condition_start_date,
    p.gender_concept_id,
    p.race_concept_id,
    p.ethnicity_concept_id,
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

pediatric_cohort AS (
  SELECT *
  FROM dx_with_age
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY person_id
    ORDER BY condition_start_date, condition_occurrence_id
  ) = 1
),

cohort_patient_dimensions AS (
  SELECT
    person_id,
    CASE
      WHEN age_at_diagnosis BETWEEN 0 AND 4 THEN '0-4'
      WHEN age_at_diagnosis BETWEEN 5 AND 9 THEN '5-9'
      WHEN age_at_diagnosis BETWEEN 10 AND 14 THEN '10-14'
      WHEN age_at_diagnosis BETWEEN 15 AND 18 THEN '15-18'
    END AS age_group,
    CASE
      WHEN gender_concept_id = 8507 THEN 'Male'
      WHEN gender_concept_id = 8532 THEN 'Female'
      WHEN gender_concept_id = 0 OR gender_concept_id IS NULL THEN 'Unknown or missing'
      ELSE 'Other'
    END AS sex,
    CASE
      WHEN race_concept_id = 8657 THEN 'American Indian or Alaska Native'
      WHEN race_concept_id = 8515 THEN 'Asian'
      WHEN race_concept_id = 8557 THEN 'Native Hawaiian or Other Pacific Islander'
      WHEN race_concept_id = 8516 THEN 'Black or African American'
      WHEN race_concept_id = 8527 THEN 'White'
      WHEN race_concept_id = 0 OR race_concept_id IS NULL THEN 'Unknown or missing'
      ELSE 'Other race'
    END AS race,
    CASE
      WHEN ethnicity_concept_id = 38003563 THEN 'Hispanic or Latino'
      WHEN ethnicity_concept_id = 38003564 THEN 'Not Hispanic or Latino'
      ELSE 'Other or missing'
    END AS ethnicity
  FROM pediatric_cohort
  WHERE age_at_diagnosis BETWEEN 0 AND 18
),

demographic_rows AS (
  SELECT
    'Age at index' AS characteristic,
    age_group AS category,
    person_id
  FROM cohort_patient_dimensions

  UNION ALL

  SELECT
    'Sex' AS characteristic,
    sex AS category,
    person_id
  FROM cohort_patient_dimensions

  UNION ALL

  SELECT
    'Race' AS characteristic,
    race AS category,
    person_id
  FROM cohort_patient_dimensions

  UNION ALL

  SELECT
    'Ethnicity' AS characteristic,
    ethnicity AS category,
    person_id
  FROM cohort_patient_dimensions
),

denominator AS (
  SELECT COUNT(DISTINCT person_id) AS patient_total
  FROM cohort_patient_dimensions
)

SELECT
  d.characteristic,
  d.category,
  COUNT(DISTINCT d.person_id) AS patient_count,
  ROUND(
    SAFE_DIVIDE(COUNT(DISTINCT d.person_id), denominator.patient_total) * 100,
    1
  ) AS percentage
FROM demographic_rows AS d
CROSS JOIN denominator
GROUP BY
  d.characteristic,
  d.category,
  denominator.patient_total
ORDER BY
  CASE d.characteristic
    WHEN 'Age at index' THEN 1
    WHEN 'Sex' THEN 2
    WHEN 'Race' THEN 3
    WHEN 'Ethnicity' THEN 4
  END,
  d.category;
