-- Pediatric brain tumor cohort: one row per patient.
-- Exact concept ancestors are expanded to all available descendants.
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
    p.birth_datetime,
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

first_dx AS (
  SELECT *
  FROM dx_with_age
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY person_id
    ORDER BY condition_start_date, condition_occurrence_id
  ) = 1
)

SELECT
  person_id,
  condition_start_date AS index_date,
  age_at_diagnosis AS age_at_index,
  condition_concept_id AS index_condition_concept_id,
  birth_datetime,
  gender_concept_id,
  race_concept_id,
  ethnicity_concept_id
FROM first_dx
WHERE age_at_diagnosis BETWEEN 0 AND 18;
