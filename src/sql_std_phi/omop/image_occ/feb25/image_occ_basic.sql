
----------------------------------
--- Basic Counts and Data Size  ---
--- For Feb-Aug 2025: Same as Nov (no JSON needed)
-----------------------------------
SELECT count(distinct(modality_source_value)) as counts, 'counts_modality_type' as flag FROM  `@oncology_prod.@oncology_omop.image_occurrence` 
union all 
SELECT count(distinct(anatomic_site_source_value)) as counts, 'counts_anatomic_type' as flag FROM `@oncology_prod.@oncology_omop.image_occurrence` 
union all
select count(distinct(image_study_uid)) as counts, 'counts_study' as flag from `@oncology_prod.@oncology_omop.image_occurrence`
union all
select count(distinct(image_series_uid)) as counts, 'counts_series' as flag from `@oncology_prod.@oncology_omop.image_occurrence`
union all
select count(distinct(visit_occurrence_id)) as counts, 'counts_visit_occ' as flag from `@oncology_prod.@oncology_omop.image_occurrence`
union all
select count(distinct(_accession_number)) as counts, 'counts_accession_number' as flag from `@oncology_prod.@oncology_omop.image_occurrence`