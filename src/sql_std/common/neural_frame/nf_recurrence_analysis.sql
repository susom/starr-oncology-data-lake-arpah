--------------------------------------------------------------------------
-- Recurrence Analysis
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventtypeofrecurrence,
  eventtypeofrecurrencedescription,
  eventrecurrencesite1,
  eventrecurrencesite2,
  eventrecurrencesite3,
  count(distinct nfpatienteventid) as recurrence_events,
  count(distinct nfpatientsetid) as cases_with_recurrence,
  count(distinct person_id) as patients_with_recurrence
from event_data
where eventtypeofrecurrence is not null
group by 
  eventtypeofrecurrence,
  eventtypeofrecurrencedescription,
  eventrecurrencesite1,
  eventrecurrencesite2,
  eventrecurrencesite3
order by cases_with_recurrence desc
