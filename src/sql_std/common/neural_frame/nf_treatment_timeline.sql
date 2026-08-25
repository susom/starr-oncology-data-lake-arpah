--------------------------------------------------------------------------
-- Treatment Timeline Analysis
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 
  nfcaseentityid,
  person_id,
  eventtype,
  eventtypedescription,
  eventdate,
  eventradiationdateended,
  eventrxdatesurgicaldisch,
  date_diff(eventradiationdateended, eventdate, day) as radiation_duration_days,
  date_diff(eventrxdatesurgicaldisch, eventdate, day) as post_surgical_days
from event_data
where eventdate is not null
  and (eventradiationdateended is not null or eventrxdatesurgicaldisch is not null)
order by nfcaseentityid, eventdate
