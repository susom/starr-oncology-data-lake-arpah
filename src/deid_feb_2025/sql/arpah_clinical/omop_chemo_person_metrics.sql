with
person as (select * from `@oncology_prod.@oncology_omop.person`),
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
)
  select
  distinct
  count(distinct op.person_source_value) patient_count
  from
  chemo_med
  join drug_era de on chemo_med.concept_id = de.drug_concept_id
  join person op on de.person_id = op.person_id
