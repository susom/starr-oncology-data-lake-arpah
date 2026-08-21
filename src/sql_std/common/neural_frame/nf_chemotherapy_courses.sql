--------------------------------------------------------------------------
-- Chemotherapy Course Summary
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 
  eventcoursenumber,
  eventcoursenumberdescription,
  count(distinct nfpatienteventid) as chemo_events,
  count(distinct nfcaseentityid) as cases_receiving_chemo,
  count(distinct person_id) as patients_receiving_chemo
from event_data
where eventcoursenumber is not null 
  and eventrxsummchemo is not null
group by eventcoursenumber, eventcoursenumberdescription
order by eventcoursenumber asc
