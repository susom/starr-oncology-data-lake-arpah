-------------------------------------------------------------------------
-- this query generates tb patients who had chemo from arpah-cohort --
------------------------------------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort_v2`),
concept as (select * from `@oncology_prod.@oncology_omop.concept`),
concept_ancestor as (select * from `@oncology_prod.@oncology_omop.concept_ancestor`),
drug_era as (select * from `@oncology_prod.@oncology_omop.drug_era`),
chemo_med as
(
  select distinct c.*
    from concept c
    join concept_ancestor ca on c.concept_id = ca.descendant_concept_id
    and ca.ancestor_concept_id in (21601386,724009)
    and c.invalid_reason is null
),
tumor_board_patients 
AS ( select person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join drug_era on person.person_id = drug_era.person_id
inner join chemo_med on chemo_med.concept_id = drug_era.drug_concept_id
