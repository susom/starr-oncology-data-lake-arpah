WITH
  person AS (
  SELECT
    *
  FROM `@oncology_prod.@oncology_omop.person`),
  scr AS (
  SELECT
    *
  FROM
    `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
    where nfcasestatus ="Completed" and 
     (LOWER(primarysiteDescription) LIKE '%lung%'
      OR LOWER(primarysiteDescription) LIKE '%bronchus%'
      OR LOWER(primarysiteDescription) LIKE '%thymus%' )),
  scr_omop AS (
  SELECT
    DISTINCT p.person_id,
    p.person_source_value,
    scr.*
  FROM
    scr
  INNER JOIN
    person p
  ON
    json_value(p.person_source_value, '.$stanford_patient_uid') = scr.stanford_patient_uid
),
  stage_transform AS (
  SELECT
    DISTINCT person_source_value,
    CASE
      WHEN (tnmclinstagegroup IS NULL OR tnmclinstagegroup IN ('88', '99')) THEN 'Unknown'
      WHEN tnmclinstagegroup LIKE '1%' THEN '1'
      WHEN tnmclinstagegroup LIKE '2%' THEN '2'
      WHEN tnmclinstagegroup LIKE '3%' THEN '3'
      WHEN tnmclinstagegroup LIKE '4%' THEN '4'
      WHEN tnmclinstagegroup IN ('OccultCarcinoma') THEN 'Occult'
      ELSE tnmclinstagegroup
  END
    tnmclinstagegroup,
    CASE
      WHEN (tnmpathstagegroup IS NULL OR tnmpathstagegroup IN ('88', '99')) THEN 'Unknown'
      WHEN tnmpathstagegroup LIKE '1%' THEN '1'
      WHEN tnmpathstagegroup LIKE '2%' THEN '2'
      WHEN tnmpathstagegroup LIKE '3%' THEN '3'
      WHEN tnmpathstagegroup LIKE '4%' THEN '4'
      WHEN tnmpathstagegroup IN ('OccultCarcinoma') THEN 'Occult'
      ELSE tnmpathstagegroup
  END
    tnmpathstagegroup,
    CASE
      WHEN (ajccTnmPathStageGroup IS NULL OR ajccTnmPathStageGroup IN ('88', '99')) THEN 'Unknown'
      WHEN (ajccTnmPathStageGroup IS NULL
      OR ajccTnmPathStageGroup IN ('88',
        '99')) THEN 'Unknown'
      WHEN ajccTnmPathStageGroup IN ('I', 'IA1', 'IA2', 'IA3', 'IB') THEN '1'
      WHEN ajccTnmPathStageGroup IN ('II',
      'IIA',
      'IIB',
      'IIE') THEN '2'
      WHEN ajccTnmPathStageGroup IN ('IIIA', 'IIIB') THEN '3'
      WHEN ajccTnmPathStageGroup IN ('IV',
      'IVA',
      'IVB') THEN '4'
      WHEN ajccTnmPathStageGroup IN ('OccultCarcinoma') THEN 'Occult'
      ELSE ajccTnmPathStageGroup
  END
    ajccTnmPathStageGroup,
    CASE
      WHEN (ajccTnmClinStageGroup IS NULL OR ajccTnmClinStageGroup IN ('88', '99')) THEN 'Unknown'
      WHEN (ajccTnmClinStageGroup IS NULL
      OR ajccTnmClinStageGroup IN ('88',
        '99')) THEN 'Unknown'
      WHEN ajccTnmClinStageGroup IN ('I', 'IA1', 'IA2', 'IA3', 'IB', 'IE') THEN '1'
      WHEN ajccTnmClinStageGroup IN ('II',
      'IIA',
      'IIB',
      'IIE',
      'II bulky') THEN '2'
      WHEN ajccTnmClinStageGroup IN ('IIIA', 'IIIB', 'IIIC') THEN '3'
      WHEN ajccTnmClinStageGroup IN ('IV',
      'IVA',
      'IVB') THEN '4'
      WHEN ajccTnmClinStageGroup IN ('OccultCarcinoma') THEN 'Occult'
      ELSE ajccTnmClinStageGroup
  END
    ajccTnmClinStageGroup,
    CASE
      WHEN (derivedAjcc6StageGrpDescription IS NULL OR derivedAjcc6StageGrpDescription IN ('UNK: Stage Unknown', 'NA: Not applicable', 'UNK', 'NA')) THEN 'Unknown'
      WHEN (derivedAjcc6StageGrpDescription IS NULL
      OR derivedAjcc6StageGrpDescription IN ('88',
        '99')) THEN 'Unknown'
      WHEN derivedAjcc6StageGrpDescription IN ('0: Stage 0') THEN '0'
      WHEN derivedAjcc6StageGrpDescription IN ('IA',
      'IA: Stage IA',
      'IB',
      'IB: Stage IB',
      'IE: Stage IE (lymphoma only)',
      'IEA: Stage IEA (lymphoma only)',
      'IEB: Stage IEB (lymphoma only)') THEN '1'
      WHEN derivedAjcc6StageGrpDescription IN ('IIA: Stage IIA', 'IIB', 'IIB', 'IIB: Stage IIB', 'IIE: Stage IIE (lymphoma only)', 'IIEA: Stage IIEA (lymphoma only)', 'IIEB: Stage IIEB (lymphoma only)') THEN '2'
      WHEN derivedAjcc6StageGrpDescription IN ('IIIA',
      'IIIB',
      'IIIA: Stage IIIA',
      'IIIB: Stage IIIB') THEN '3'
      WHEN derivedAjcc6StageGrpDescription IN ('IV', 'IV: Stage IV', 'IVA: Stage IVA', 'IVB: Stage IVB') THEN '4'
      WHEN derivedAjcc6StageGrpDescription IN ('OCCULT',
      'OCCULT: Stage Occult') THEN 'Occult'
      ELSE derivedAjcc6StageGrpDescription
  END
    derivedAjcc6StageGrpDescription,
    CASE
      WHEN (derivedAjcc7StageGrpDescription IS NULL OR derivedAjcc7StageGrpDescription IN ('UNK: Stage Unknown', 'NA: Not applicable', 'UNK', 'NA')) THEN 'Unknown'
      WHEN (derivedAjcc7StageGrpDescription IS NULL
      OR derivedAjcc7StageGrpDescription IN ('88',
        '99')) THEN 'Unknown'
      WHEN derivedAjcc7StageGrpDescription IN ('0: Stage 0') THEN '0'
      WHEN derivedAjcc7StageGrpDescription IN ('IA',
      'IA: Stage IA',
      'IB',
      'IB: Stage IB',
      'IE: Stage IE (lymphoma only)',
      'IEA: Stage IEA (lymphoma only)',
      'Stage IEB (lymphoma only)',
      'IEB: Stage IEB (lymphoma only)') THEN '1'
      WHEN derivedAjcc7StageGrpDescription IN ('IIA', 'IIA: Stage IIA', 'IIB', 'IIB', 'IIB: Stage IIB', 'IIE: Stage IIE (lymphoma only)', 'IIEA: Stage IIEA (lymphoma only)', 'IIEB: Stage IIEB (lymphoma only)') THEN '2'
      WHEN derivedAjcc7StageGrpDescription IN ('III',
      'III: Stage III',
      'IIIA',
      'IIIB',
      'IIIA: Stage IIIA',
      'IIIB: Stage IIIB') THEN '3'
      WHEN derivedAjcc7StageGrpDescription IN ('IV', 'IV: Stage IV', 'IVA: Stage IVA', 'IVB: Stage IVB') THEN '4'
      WHEN derivedAjcc7StageGrpDescription IN ('OCCULT',
      'OCCULT: Stage Occult') THEN 'Occult'
      ELSE derivedAjcc7StageGrpDescription
  END
    derivedAjcc7StageGrpDescription
  FROM
    scr_omop
 )
SELECT
  COUNT(DISTINCT person_source_value) patient_count,
  CASE
    WHEN ( tnmclinstagegroup = 'Unknown' AND tnmpathstagegroup = 'Unknown' AND ajccTnmPathStageGroup = 'Unknown' AND ajccTnmClinStageGroup = 'Unknown' AND derivedAjcc6StageGrpDescription = 'Unknown' AND derivedAjcc7StageGrpDescription = 'Unknown' ) THEN 'Unknown'
    WHEN ( tnmclinstagegroup IN ('Unknown',
      '1')
    AND tnmpathstagegroup IN ('Unknown',
      '1')
    AND ajccTnmPathStageGroup IN ('Unknown',
      '1')
    AND ajccTnmClinStageGroup IN ('Unknown',
      '1')
    AND derivedAjcc6StageGrpDescription IN ('Unknown',
      '1')
    AND derivedAjcc7StageGrpDescription IN ('Unknown',
      '1') ) THEN '1'
    WHEN ( tnmclinstagegroup IN ('Unknown', '2') AND tnmpathstagegroup IN ('Unknown', '2') AND ajccTnmPathStageGroup IN ('Unknown', '2') AND ajccTnmClinStageGroup IN ('Unknown', '2') AND derivedAjcc6StageGrpDescription IN ('Unknown', '2') AND derivedAjcc7StageGrpDescription IN ('Unknown', '2') ) THEN '2'
    WHEN ( tnmclinstagegroup IN ('Unknown',
      '3')
    AND tnmpathstagegroup IN ('Unknown',
      '3')
    AND ajccTnmPathStageGroup IN ('Unknown',
      '3')
    AND ajccTnmClinStageGroup IN ('Unknown',
      '3')
    AND derivedAjcc6StageGrpDescription IN ('Unknown',
      '3')
    AND derivedAjcc7StageGrpDescription IN ('Unknown',
      '3') ) THEN '3'
    WHEN ( tnmclinstagegroup IN ('Unknown', '4') AND tnmpathstagegroup IN ('Unknown', '4') AND ajccTnmPathStageGroup IN ('Unknown', '4') AND ajccTnmClinStageGroup IN ('Unknown', '4') AND derivedAjcc6StageGrpDescription IN ('Unknown', '4') AND derivedAjcc7StageGrpDescription IN ('Unknown', '4') ) THEN '4'
    WHEN ( tnmclinstagegroup IN ('Unknown',
      '0')
    AND tnmpathstagegroup IN ('Unknown',
      '0')
    AND ajccTnmPathStageGroup IN ('Unknown',
      '0')
    AND ajccTnmClinStageGroup IN ('Unknown',
      '0')
    AND derivedAjcc6StageGrpDescription IN ('Unknown',
      '0')
    AND derivedAjcc7StageGrpDescription IN ('Unknown',
      '0') ) THEN '0'
    WHEN ( tnmclinstagegroup IN ('Unknown', 'Occult') AND tnmpathstagegroup IN ('Unknown', 'Occult') AND ajccTnmPathStageGroup IN ('Unknown', 'Occult') AND ajccTnmClinStageGroup IN ('Unknown', 'Occult') AND derivedAjcc6StageGrpDescription IN ('Unknown', 'Occult') AND derivedAjcc7StageGrpDescription IN ('Unknown', 'Occult') ) THEN 'Occult'
    WHEN ( tnmclinstagegroup IN ( '4')
    OR tnmpathstagegroup IN ('4')
    OR ajccTnmPathStageGroup IN ('4')
    OR ajccTnmClinStageGroup IN ('4')
    OR derivedAjcc6StageGrpDescription IN ('4')
    OR derivedAjcc7StageGrpDescription IN ('4') ) THEN '4'
    WHEN ( tnmclinstagegroup IN ( '3') OR tnmpathstagegroup IN ('3') OR ajccTnmPathStageGroup IN ('3') OR ajccTnmClinStageGroup IN ('3') OR derivedAjcc6StageGrpDescription IN ('3') OR derivedAjcc7StageGrpDescription IN ('3') ) THEN '3'
    WHEN ( tnmclinstagegroup IN ( '2')
    OR tnmpathstagegroup IN ('2')
    OR ajccTnmPathStageGroup IN ('2')
    OR ajccTnmClinStageGroup IN ('2')
    OR derivedAjcc6StageGrpDescription IN ('2')
    OR derivedAjcc7StageGrpDescription IN ('2') ) THEN '2'
    WHEN ( tnmclinstagegroup IN ( '1') OR tnmpathstagegroup IN ('1') OR ajccTnmPathStageGroup IN ('1') OR ajccTnmClinStageGroup IN ('1') OR derivedAjcc6StageGrpDescription IN ('1') OR derivedAjcc7StageGrpDescription IN ('1') ) THEN '1'
    ELSE CONCAT(tnmclinstagegroup,tnmpathstagegroup, ajccTnmPathStageGroup,ajccTnmClinStageGroup,derivedAjcc6StageGrpDescription,derivedAjcc7StageGrpDescription)
END
  derived_stage
FROM
  stage_transform
GROUP BY
  derived_stage

