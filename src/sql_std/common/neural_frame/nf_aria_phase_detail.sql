--------------------------------------------------------------------------
-- ARIA Phase-Level Detail by Column Coverage (Radiation events only)
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 'Total Dose' as aria_field,
  count(distinct person_id) as patients,
  count(distinct nfcaseentityid) as cases
from event_data where eventphasetotaldose is not null
union all
select 'Dose Per Fraction',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventphasedoseperfraction is not null
union all
select 'Number of Fractions',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventphasenumberoffractions is not null
union all
select 'Treatment Volume',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventphaseradiationtreatmentvolume is not null
union all
select 'Draining Lymph Nodes',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventphaseradiationdraininglymphnodes is not null
union all
select 'External Beam Planning Tech',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventphaseradiationexternalbeamplanningtech is not null
union all
select 'Treatment Modality',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventphaseradiationtreatmentmodality is not null
union all
select 'Radiation Phase',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventradiationphase is not null
union all
select 'Radiation End Date',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from event_data where eventradiationdateended is not null
order by patients desc
