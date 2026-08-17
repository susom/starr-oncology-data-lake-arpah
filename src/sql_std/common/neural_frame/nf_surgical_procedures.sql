--------------------------------------------------------------------------
-- Surgical Procedure Summary
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventrxsummsurgprimsite,
  eventrxsummsurgprimsitedescription,
  eventrxsummsurgicalapproch,
  eventrxsummsurgicalapprochdescription,
  eventrxsummsurgicalmargins,
  eventrxsummsurgicalmarginsdescription,
  count(distinct nfpatienteventid) as surgical_events,
  count(distinct nfpatientsetid) as cases_with_surgery
from event_data
where eventrxsummsurgprimsite is not null
group by 
  eventrxsummsurgprimsite,
  eventrxsummsurgprimsitedescription,
  eventrxsummsurgicalapproch,
  eventrxsummsurgicalapprochdescription,
  eventrxsummsurgicalmargins,
  eventrxsummsurgicalmarginsdescription
order by cases_with_surgery desc
