
with demographics as (SELECT
  COUNT(person.person_id) as n_patients,
  COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365 < 18) as n_age_last_seen_0_17,
  COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365 >= 18 AND (DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365 < 45) as n_age_last_seen_18_44,
  COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365 >= 45 AND (DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365 < 65) as n_age_last_seen_45_64,
  COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY))/365 >= 65) as n_age_last_seen_65_plus,
  COUNTIF(max_vis.latest_visit_start_datetime IS NULL) as n_unknown_age_no_omop_visits,
  COUNTIF(gender_concept_id = 8507) AS n_sex_male,
  COUNTIF(gender_concept_id = 8532) AS n_sex_female,
  COUNTIF(gender_concept_id = 0 OR gender_concept_id IS NULL) as n_sex_unknown,
  COUNTIF(gender_concept_id NOT IN (8532, 8507, 0)) AS n_sex_other,
  COUNTIF(race_concept_id = 8657) as n_race_american_indian_alaska_native,
  COUNTIF(race_concept_id = 8515) AS n_race_asian,
  COUNTIF(race_concept_id = 8557) AS n_race_native_hawaii_pacific_isl,
  COUNTIF(race_concept_id = 8516) AS n_race_black,
  COUNTIF(race_concept_id = 8527) AS n_race_white,
  COUNTIF(race_concept_id = 0) as n_race_other_unknown,
  COUNTIF(ethnicity_concept_id = 38003563) as n_ethnicity_hispanic_latino,
  COUNTIF(ethnicity_concept_id = 38003564) as n_ethnicity_NOT_hispanic_latino,
  COUNTIF(ethnicity_concept_id NOT IN (38003563, 38003564)) as n_ethnicity_other_missing,
  FROM `@oncology_prod.@oncology_omop.person` person
  LEFT JOIN
    (SELECT person_id, COUNT(DISTINCT visit_occurrence_id) as n_visits, MAX(visit_start_datetime) as latest_visit_start_datetime
    FROM `@oncology_prod.@oncology_omop.visit_occurrence`
    GROUP BY person_id) max_vis
  ON person.person_id = max_vis.person_id
),
transpose_cols as (
select *
from demographics
unpivot(counts for description IN (
  n_patients,
  n_age_last_seen_0_17,
  n_age_last_seen_18_44,
  n_age_last_seen_45_64,
  n_age_last_seen_65_plus,
  n_unknown_age_no_omop_visits,
  n_sex_male,
  n_sex_female,
  n_sex_other,
  n_sex_unknown,
  n_race_american_indian_alaska_native,
  n_race_asian,
  n_race_native_hawaii_pacific_isl,
  n_race_black,
  n_race_white,
  n_race_other_unknown,
  n_ethnicity_hispanic_latino,
  n_ethnicity_NOT_hispanic_latino,
  n_ethnicity_other_missing))
)
select description, counts, FORMAT("%.2f", counts/(select counts from transpose_cols where description = 'n_patients')) as percents
from transpose_cols