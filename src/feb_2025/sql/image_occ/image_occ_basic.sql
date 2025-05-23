
----------------------------------
--- Basic Counts and Data Size  ---
-----------------------------------
SELECT count(distinct(modality_source_value)) as counts, 'counts_modality_type' as flag FROM  `@oncology_prod.@oncology_omop.image_occurrence` 
union all 
SELECT count(distinct(anatomic_site_source_value)) as counts, 'counts_anatomic_type' as flag FROM `@oncology_prod.@oncology_omop.image_occurrence` 
union all
SELECT
  ROUND(SUM(size_bytes)/1024/1024/1024) AS counts,  'size_gb' as flag
FROM
  `@oncology_prod.@oncology_omop.__TABLES__`
WHERE
  table_id = 'image_occurrence'
  union all
select count(distinct(image_study_uid)) as counts, 'counts_study' as flag from `@oncology_prod.@oncology_omop.image_occurrence`
union all
select count(distinct(image_series_uid)) as counts, 'counts_series' as flag from `@oncology_prod.@oncology_omop.image_occurrence`
