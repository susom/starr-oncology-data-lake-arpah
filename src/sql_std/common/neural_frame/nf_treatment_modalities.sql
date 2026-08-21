--------------------------------------------------------------------------
-- Treatment Modalities Summary (non-exclusive: patients can appear in multiple)
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
    and eventdate is not null
),
modalities as (
  select 'Chemotherapy' as treatment_modality,
    count(distinct nfcaseentityid) as case_count,
    count(distinct person_id) as patient_count
  from event_data where eventrxsummchemo is not null
  union all
  select 'Radiation',
    count(distinct nfcaseentityid),
    count(distinct person_id)
  from event_data
  union all
  select 'Surgery',
    count(distinct nfcaseentityid),
    count(distinct person_id)
  from event_data where eventrxsummsurgprimsite is not null
  union all
  select 'Hormone Therapy',
    count(distinct nfcaseentityid),
    count(distinct person_id)
  from event_data where eventrxsummhormone is not null
  union all
  select 'Biologic Response Modifier',
    count(distinct nfcaseentityid),
    count(distinct person_id)
  from event_data where eventrxsummbrm is not null
)
select * from modalities
order by case_count desc
