--------------------------------------------------------------------------
-- Event Temporal Trends by Year
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 
  substr(cast(eventdate as string), 1, 4) as year,
  count(distinct person_id) as distinct_patients,
  count(*) as total_events
from event_data
where eventdate is not null
group by year
order by year
