--- death counts by source and overlap ---
------------------------------------------
WITH omop_death AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_omop.death`
  WHERE death_date IS NOT NULL
),

neuralframe_death AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes`
  WHERE vitalstatusdescription = 'Dead'
),

ext_death AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_omop._external_death_records`
),

all_sources AS (
  SELECT
    person_id,
    MAX(CASE WHEN src = 'omop'          THEN 1 ELSE 0 END) AS has_omop,
    MAX(CASE WHEN src = 'neuralframe'   THEN 1 ELSE 0 END) AS has_neuralframe,
    MAX(CASE WHEN src = 'ext_death'     THEN 1 ELSE 0 END) AS has_ext_death
  FROM (
    SELECT person_id, 'omop'        AS src FROM omop_death
    UNION ALL
    SELECT person_id, 'neuralframe' AS src FROM neuralframe_death
    UNION ALL
    SELECT person_id, 'ext_death'   AS src FROM ext_death
  )
  GROUP BY person_id
),

combinations AS (
  SELECT
    person_id,
    CASE
      WHEN has_omop = 1 AND has_neuralframe = 0 AND has_ext_death = 0
        THEN 'OMOP only'
      WHEN has_omop = 0 AND has_neuralframe = 1 AND has_ext_death = 0
        THEN 'NeuralFrame only'
      WHEN has_omop = 0 AND has_neuralframe = 0 AND has_ext_death = 1
        THEN 'External only'
      WHEN has_omop = 1 AND has_neuralframe = 1 AND has_ext_death = 0
        THEN 'OMOP + NeuralFrame'
      WHEN has_omop = 1 AND has_neuralframe = 0 AND has_ext_death = 1
        THEN 'OMOP + External'
      WHEN has_omop = 0 AND has_neuralframe = 1 AND has_ext_death = 1
        THEN 'NeuralFrame + External'
      WHEN has_omop = 1 AND has_neuralframe = 1 AND has_ext_death = 1
        THEN 'OMOP + NeuralFrame + External'
      ELSE 'Other'
    END AS source_combination
  FROM all_sources
),

-- row per source showing total + overlap with external death
source_totals AS (
  SELECT 'OMOP death'        AS death_source, COUNT(*)                           AS n_total,
         SUM(has_ext_death)  AS n_overlap_with_ext_death
  FROM all_sources WHERE has_omop = 1
  UNION ALL
  SELECT 'NeuralFrame death' AS death_source, COUNT(*)                           AS n_total,
         SUM(has_ext_death)  AS n_overlap_with_ext_death
  FROM all_sources WHERE has_neuralframe = 1
  UNION ALL
  SELECT 'External death'    AS death_source, COUNT(*)                           AS n_total,
         SUM(has_ext_death)  AS n_overlap_with_ext_death
  FROM all_sources WHERE has_ext_death = 1
)

-- Part 1: per-source totals and overlap with external death records
SELECT
  death_source,
  n_total,
  n_overlap_with_ext_death,
  ROUND(100 * n_overlap_with_ext_death / n_total, 1) AS pct_overlap_with_ext_death
FROM source_totals

UNION ALL

-- Part 2: mutually exclusive combination counts
SELECT
  source_combination                               AS death_source,
  COUNT(DISTINCT person_id)                        AS n_total,
  NULL                                             AS n_overlap_with_ext_death,
  ROUND(
    100 * COUNT(DISTINCT person_id)
      / SUM(COUNT(DISTINCT person_id)) OVER (),
    1
  )                                                AS pct_overlap_with_ext_death
FROM combinations
GROUP BY source_combination
ORDER BY n_total DESC;
