--------------------------------------------------------------------------
-- Surgical Procedure Summary
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 
  eventrxsummsurgprimsitedescription as surgery_type,
  count(distinct nfpatienteventid) as surgical_events,
  count(distinct nfcaseentityid) as cases_with_surgery,
  count(distinct person_id) as patients_with_surgery
from event_data
where eventrxsummsurgprimsite is not null
group by surgery_type
order by cases_with_surgery desc
