WITH
person AS (
    SELECT * FROM `@oncology_prod.@oncology_omop.person`
),
tb_visits AS (
    SELECT * FROM  `@oncology_prod.@oncology_omop.visit_occurrence`
),
scr AS (
    SELECT * FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
tumor_board_patients AS (
     select person_id from tb_visits
    where  LOWER(visit_source_value) LIKE '%tumor board%'
),
scr_thoracic_patients AS (
    SELECT DISTINCT person_id
    FROM scr
    WHERE LOWER(primarysiteDescription) LIKE '%lung%'
       OR LOWER(primarysiteDescription) LIKE '%bronchus%'
       OR LOWER(primarysiteDescription) LIKE '%thymus%'
),
tb_thoracic_patients AS (
    SELECT DISTINCT person.person_id
    FROM tumor_board_patients tb
    INNER JOIN person ON person.person_id = tb.person_id
    INNER JOIN scr_thoracic_patients ON person.person_id = scr_thoracic_patients.person_id
),
demographics AS (
    SELECT
        COUNT(person.person_id) AS n_patients,
        COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY)) / 365 < 18) AS n_age_last_seen_0_17,
        COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY)) / 365 >= 18 AND (DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY)) / 365 < 45) AS n_age_last_seen_18_44,
        COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY)) / 365 >= 45 AND (DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY)) / 365 < 65) AS n_age_last_seen_45_64,
        COUNTIF((DATE_DIFF(max_vis.latest_visit_start_datetime, person.birth_datetime, DAY)) / 365 >= 65) AS n_age_last_seen_65_plus,
        COUNTIF(max_vis.latest_visit_start_datetime IS NULL) AS n_unknown_age_no_omop_visits,
        COUNTIF(gender_concept_id = 8507) AS n_sex_male,
        COUNTIF(gender_concept_id = 8532) AS n_sex_female,
        COUNTIF(gender_concept_id = 0 OR gender_concept_id IS NULL) AS n_sex_unknown,
        COUNTIF(gender_concept_id NOT IN (8532, 8507, 0)) AS n_sex_other,
        COUNTIF(race_concept_id = 8657) AS n_race_american_indian_alaska_native,
        COUNTIF(race_concept_id = 8515) AS n_race_asian,
        COUNTIF(race_concept_id = 8557) AS n_race_native_hawaii_pacific_isl,
        COUNTIF(race_concept_id = 8516) AS n_race_black,
        COUNTIF(race_concept_id = 8527) AS n_race_white,
        COUNTIF(race_concept_id = 0) AS n_race_other_unknown,
        COUNTIF(ethnicity_concept_id = 38003563) AS n_ethnicity_hispanic_latino,
        COUNTIF(ethnicity_concept_id = 38003564) AS n_ethnicity_NOT_hispanic_latino,
        COUNTIF(ethnicity_concept_id NOT IN (38003563, 38003564)) AS n_ethnicity_other_missing
    FROM `@oncology_prod.@oncology_omop.person` person
    LEFT JOIN (
        SELECT person_id, COUNT(DISTINCT visit_occurrence_id) AS n_visits, MAX(visit_start_datetime) AS latest_visit_start_datetime
        FROM `@oncology_prod.@oncology_omop.visit_occurrence`
        GROUP BY person_id
    ) max_vis ON person.person_id = max_vis.person_id
    WHERE person.person_id IN (SELECT person_id FROM tb_thoracic_patients)
),
transpose_cols AS (
    SELECT *
    FROM demographics
    UNPIVOT(counts FOR description IN (
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
        n_ethnicity_other_missing
    ))
)
SELECT description, counts, FORMAT("%.2f", counts / (SELECT counts FROM transpose_cols WHERE description = 'n_patients')) AS percents
FROM transpose_cols
