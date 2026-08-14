--- unique pts counts -mutually exclusive ---
---------------------------------------------
WITH patient_sources AS (
  SELECT
    person_id,

    MAX(
      CASE
        WHEN external_death_record_source = 'Match on California Decedent Registry' THEN 1
        ELSE 0
      END
    ) AS has_cdph,

    MAX(
      CASE
        WHEN external_death_record_source = 'External Organization' THEN 1
        ELSE 0
      END
    ) AS has_care_everywhere,

    MAX(
      CASE
        WHEN external_death_record_source = 'DMF' THEN 1
        ELSE 0
      END
    ) AS has_dmf

  FROM @oncology_prod.@oncology_omop._death_external_death_records


  GROUP BY person_id
),

source_combinations AS (
  SELECT
    person_id,

    CASE
      WHEN has_cdph = 1
        AND has_care_everywhere = 0
        AND has_dmf = 0
        THEN 'CDPH only'

      WHEN has_cdph = 0
        AND has_care_everywhere = 1
        AND has_dmf = 0
        THEN 'Care Everywhere only'

      WHEN has_cdph = 0
        AND has_care_everywhere = 0
        AND has_dmf = 1
        THEN 'DMF only'

      WHEN has_cdph = 1
        AND has_care_everywhere = 1
        AND has_dmf = 0
        THEN 'CDPH + Care Everywhere'

      WHEN has_cdph = 1
        AND has_care_everywhere = 0
        AND has_dmf = 1
        THEN 'CDPH + DMF'

      WHEN has_cdph = 0
        AND has_care_everywhere = 1
        AND has_dmf = 1
        THEN 'Care Everywhere + DMF'

      WHEN has_cdph = 1
        AND has_care_everywhere = 1
        AND has_dmf = 1
        THEN 'CDPH + Care Everywhere + DMF'

      ELSE 'Other / Unknown'
    END AS source_combination

  FROM patient_sources
)

SELECT
  source_combination,
  COUNT(DISTINCT person_id) AS n_unique_patients,
  ROUND(
    100 * COUNT(DISTINCT person_id)
      / SUM(COUNT(DISTINCT person_id)) OVER (),
    1
  ) AS pct_unique_patients

FROM source_combinations

GROUP BY source_combination

ORDER BY n_unique_patients DESC;