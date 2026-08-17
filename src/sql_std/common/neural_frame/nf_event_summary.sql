--------------------------------------------------------------------------
-- Neural Frame Event Table Summary Statistics
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  count(distinct person_id) as total_patients,
  count(distinct nfpatientsetid) as total_cases,
  count(distinct nfpatienteventid) as total_events,
  count(distinct eventtype) as unique_event_types,
  min(eventdate) as earliest_event_date,
  max(eventdate) as latest_event_date
from event_data
where eventdate is not null
