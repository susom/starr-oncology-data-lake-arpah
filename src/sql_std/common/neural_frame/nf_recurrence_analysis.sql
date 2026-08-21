--------------------------------------------------------------------------
-- Recurrence Analysis
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 
  eventtypeofrecurrencedescription as recurrence_type,
  count(distinct nfpatienteventid) as recurrence_events,
  count(distinct nfcaseentityid) as cases_with_recurrence,
  count(distinct person_id) as patients_with_recurrence
from event_data
where eventtypeofrecurrence is not null
group by recurrence_type
order by cases_with_recurrence desc
