-- High-level demographic summary for cohort
WITH demographics AS (
  SELECT
    COUNT(person.person_id) AS total_patients,
    COUNTIF(gender_concept_id = 8532) AS n_female,
    COUNTIF(gender_concept_id = 8507) AS n_male,
    AVG((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365.25) AS avg_age,
    COUNTIF(race_concept_id = 8657) AS n_race_american_indian,
    COUNTIF(race_concept_id = 8515) AS n_race_asian,
    COUNTIF(race_concept_id = 8557) AS n_race_pacific_islander,
    COUNTIF(race_concept_id = 8516) AS n_race_black,
    COUNTIF(race_concept_id = 8527) AS n_race_white,
    COUNTIF(race_concept_id = 0) AS n_race_other_unknown
  FROM `@oncology_prod.@oncology_omop.person` person
  LEFT JOIN (
    SELECT 
      person_id, 
      MAX(visit_start_datetime) AS latest_visit_start_datetime
    FROM `@oncology_prod.@oncology_omop.visit_occurrence`
    GROUP BY person_id
  ) max_vis
  ON person.person_id = max_vis.person_id
),
race_ranked AS (
  SELECT
    'American Indian/Alaska Native' AS race_category,
    n_race_american_indian AS count
  FROM demographics
  UNION ALL
  SELECT 'Asian', n_race_asian FROM demographics
  UNION ALL
  SELECT 'Native Hawaiian/Pacific Islander', n_race_pacific_islander FROM demographics
  UNION ALL
  SELECT 'Black/African American', n_race_black FROM demographics
  UNION ALL
  SELECT 'White', n_race_white FROM demographics
  UNION ALL
  SELECT 'Other/Unknown', n_race_other_unknown FROM demographics
)
SELECT
  d.total_patients AS sample_size,
  ROUND((d.n_female / d.total_patients) * 100, 1) AS percent_female,
  ROUND(d.avg_age, 1) AS average_age,
  (SELECT race_category FROM race_ranked ORDER BY count DESC LIMIT 1) AS most_frequent_race,
  (SELECT MAX(count) FROM race_ranked) AS most_frequent_race_count,
  ROUND((SELECT MAX(count) FROM race_ranked) / d.total_patients * 100, 1) AS most_frequent_race_percent
FROM demographics d
