--- total unique death patients across all sources + breakdown by source ---
---------------------------------------------------------------------------
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

all_death_combined AS (
  SELECT person_id FROM omop_death
  UNION DISTINCT
  --SELECT person_id FROM neuralframe_death
  SELECT person_id FROM ext_death
)

-- Total unique patients across all death sources
SELECT
  'All death sources (combined)'  AS death_source,
  COUNT(DISTINCT person_id)       AS n_unique_patients
FROM all_death_combined

UNION ALL

-- Per-source counts
SELECT 'OMOP death'       AS death_source, COUNT(DISTINCT person_id) AS n_unique_patients
FROM omop_death

UNION ALL

--SELECT 'NeuralFrame death' AS death_source, COUNT(DISTINCT person_id) AS n_unique_patients
--FROM neuralframe_death

SELECT 'External death records' AS death_source, COUNT(DISTINCT person_id) AS n_unique_patients
FROM ext_death

ORDER BY n_unique_patients DESC;
