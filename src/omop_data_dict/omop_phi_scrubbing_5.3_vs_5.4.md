# PHI Scrubbing Metadata Differences: OMOP Dictionary 5.3 vs 5.4 (repo)

This report compares only PHI-related metadata columns: `phi` and `phi scrubbing operation`.

- 5.3 dictionary: `src/omop_data_dict/omop_data_dict_5.3/`
- 5.4 dictionary: `src/omop_data_dict/omop_data_dict_5.4/`

## Table coverage

- Tables in 5.3: **38**
- Tables in 5.4: **41**
- Tables in common: **36**

### Tables only in 5.3 (not compared)
- attribute_definition
- cohort_definition

### Tables only in 5.4 (not compared)
- cohort
- episode
- episode_event
- variant_occurrence
- whole_slide_imaging

## PHI metadata diffs by table

Notes:
- Field matching is case/whitespace-insensitive.
- “(blank)” means the cell was empty in the dictionary table.

### visit_detail (11 PHI-related diffs)

**Fields added in 5.4**
- discharged_to_concept_id
- discharged_to_source_value
- parent_visit_detail_id

**Fields removed in 5.4** (present in 5.3 only)
- discharge_to_concept_id
- discharge_to_source_value
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)
- visit_detail_parent_id

**Fields with changed PHI metadata**
- preceding_visit_detail_id
  - phi: 5.3=(blank) | 5.4=Yes
  - phi scrubbing operation: 5.3=SubNot Stable between Data Refreshes | 5.4=Sub Not Stable between Data Refreshes
- visit_occurrence_id
  - phi: 5.3=(blank) | 5.4=Yes
  - phi scrubbing operation: 5.3=(blank) | 5.4=Sub with Stable between Data Refreshes

### location (10 PHI-related diffs)

**Fields added in 5.4**
- country_concept_id
- country_source_value
- latitude
- longitude

**Fields removed in 5.4** (present in 5.3 only)
- latitude (available only at Stanford)
- load_table_id (Stanford construct for traceability)
- longitude (available only at Stanford)
- unit_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- _census_block_group (available only at Stanford)
  - phi scrubbing operation: 5.3=Drop | 5.4=Del
- county
  - phi: 5.3=Yes | 5.4=No

### device_exposure (8 PHI-related diffs)

**Fields added in 5.4**
- production_id
- unit_concept_id
- unit_source_concept_id
- unit_source_value

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- device_exposure_id
  - phi scrubbing operation: 5.3=SubNot Stable between Data Refreshes | 5.4=Sub Not Stable between Data Refreshes

### care_site (7 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- care_site_name
  - phi scrubbing operation: 5.3=None | 5.4=(blank)
- care_site_source_value
  - phi: 5.3=(blank) | 5.4=Yes
  - phi scrubbing operation: 5.3=None | 5.4=Del
- place_of_service_concept_id
  - phi scrubbing operation: 5.3=None | 5.4=(blank)
- place_of_service_source_value
  - phi scrubbing operation: 5.3=None | 5.4=(blank)

### observation (7 PHI-related diffs)

**Fields added in 5.4**
- obs_event_field_concept_id
- observation_event_id
- value_source_value

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- observation_source_value
  - phi: 5.3=Yes | 5.4=(blank)
  - phi scrubbing operation: 5.3=TiDE | 5.4=(blank)

### visit_occurrence (7 PHI-related diffs)

**Fields added in 5.4**
- discharged_to_concept_id
- discharged_to_source_value

**Fields removed in 5.4** (present in 5.3 only)
- discharge_to_concept_id
- discharge_to_source_value
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### image_occurrence (5 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- source_flag (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- anatomic_site_source_value
  - phi: 5.3=Yes | 5.4=(blank)
- modality_source_value
  - phi: 5.3=Yes | 5.4=(blank)

### measurement (5 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- modifier_of_event_id
- modifier_of_field_concept_id
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### note (5 PHI-related diffs)

**Fields added in 5.4**
- note_event_field_concept_id
- note_event_id

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- note_source_value
  - phi scrubbing operation: 5.3=Sub | 5.4=(blank)

### person (5 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Fields with changed PHI metadata**
- care_site_id
  - phi: 5.3=Yes | 5.4=(blank)
  - phi scrubbing operation: 5.3=Sub with Stable between Data Refreshes | 5.4=(blank)
- person_source_value
  - phi scrubbing operation: 5.3=Sub | 5.4=Del

### procedure_occurrence (5 PHI-related diffs)

**Fields added in 5.4**
- procedure_end_date
- procedure_end_datetime

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### drug_strength (4 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row _id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)
- valid_end_date
- valid_start_date

### cdm_source (3 PHI-related diffs)

**Fields added in 5.4**
- cdm_version_concept_id

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### condition_era (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### condition_occurrence (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### death (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### drug_era (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### drug_exposure (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### fact_relationship (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id
- trace_id
- unit_id

### observation_period (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### provider (3 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### concept (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### concept_ancestor (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### concept_class (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### concept_relationship (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id
- load_table_id

### concept_synonym (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### domain (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id
- load_table_id

### metadata (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table
- unit_id

### payer_plan_period (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)

### relationship (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### vocabulary (2 PHI-related diffs)

**Fields removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

