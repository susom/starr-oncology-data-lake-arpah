--------------------------------------------------------------------------
-- Thoracic Tumor Board ARIA Metrics
--------------------------------------------------------------------------

with
tb_visits as (
  select * from `@oncology_prod.@oncology_omop.visit_occurrence`
),
scr as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
events as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
),
tumor_board_patients as (
  select person_id
  from tb_visits
  where lower(visit_source_value) like '%tumor board%'
),
scr_thoracic_patients as (
  select distinct person_id
  from scr
  where lower(primarysiteDescription) like '%lung%'
     or lower(primarysiteDescription) like '%bronchus%'
     or lower(primarysiteDescription) like '%thymus%'
),
thoracic_tb_events as (
  select e.*
  from events e
  inner join tumor_board_patients tb using (person_id)
  inner join scr_thoracic_patients stp using (person_id)
  where lower(e.eventtypedescription) like '%radiation%'
)
select 'Total Dose' as aria_field,
  count(distinct person_id) as patients,
  count(distinct nfcaseentityid) as cases
from thoracic_tb_events where eventphasetotaldose is not null
union all
select 'Dose Per Fraction',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventphasedoseperfraction is not null
union all
select 'Number of Fractions',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventphasenumberoffractions is not null
union all
select 'Treatment Volume',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventphaseradiationtreatmentvolume is not null
union all
select 'Draining Lymph Nodes',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventphaseradiationdraininglymphnodes is not null
union all
select 'External Beam Planning Tech',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventphaseradiationexternalbeamplanningtech is not null
union all
select 'Treatment Modality',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventphaseradiationtreatmentmodality is not null
union all
select 'Radiation Phase',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventradiationphase is not null
union all
select 'Radiation End Date',
  count(distinct person_id),
  count(distinct nfcaseentityid)
from thoracic_tb_events where eventradiationdateended is not null
order by patients desc
