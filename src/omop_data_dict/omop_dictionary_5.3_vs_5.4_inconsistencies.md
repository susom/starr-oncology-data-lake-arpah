# OMOP Dictionary Inconsistencies: 5.3 vs 5.4 (repo)

This report compares the repo dictionaries:
- 5.3: `src/omop_data_dict/omop_data_dict_5.3/`
- 5.4: `src/omop_data_dict/omop_data_dict_5.4/`

## Table-level differences

- Tables in 5.3: **38**
- Tables in 5.4: **41**
- Tables in common: **36**

### Only in 5.3
- attribute_definition
- cohort_definition

### Only in 5.4
- cohort
- episode
- episode_event
- variant_occurrence
- whole_slide_imaging

## Column-level inconsistencies (common tables)

Notes:
- Field name matching is case/whitespace-insensitive.
- “(blank)” means the cell was empty in the dictionary markdown table.

### visit_detail (11 diffs)

**Added in 5.4**
- discharged_to_concept_id
- discharged_to_source_value
- parent_visit_detail_id

**Removed in 5.4** (present in 5.3 only)
- discharge_to_concept_id
- discharge_to_source_value
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)
- visit_detail_parent_id

**Changed** (same field, different metadata)
- preceding_visit_detail_id: phi, phi_scrubbing_operation
  - phi: 5.3=(blank) | 5.4=Yes
  - phi_scrubbing_operation: 5.3=SubNot Stable between Data Refreshes | 5.4=Sub Not Stable between Data Refreshes
- visit_occurrence_id: phi, phi_scrubbing_operation
  - phi: 5.3=(blank) | 5.4=Yes
  - phi_scrubbing_operation: 5.3=(blank) | 5.4=Sub with Stable between Data Refreshes

### location (10 diffs)

**Added in 5.4**
- country_concept_id
- country_source_value
- latitude
- longitude

**Removed in 5.4** (present in 5.3 only)
- latitude (available only at Stanford)
- load_table_id (Stanford construct for traceability)
- longitude (available only at Stanford)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- _census_block_group (available only at Stanford): phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=Drop | 5.4=Del
- county: phi
  - phi: 5.3=Yes | 5.4=No

### care_site (9 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- care_site_id: phi
  - phi: 5.3=(blank) | 5.4=Yes
- care_site_name: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=None | 5.4=(blank)
- care_site_source_value: phi, phi_scrubbing_operation
  - phi: 5.3=(blank) | 5.4=Yes
  - phi_scrubbing_operation: 5.3=None | 5.4=Del
- location_id: phi
  - phi: 5.3=(blank) | 5.4=Yes
- place_of_service_concept_id: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=None | 5.4=(blank)
- place_of_service_source_value: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=None | 5.4=(blank)

### device_exposure (8 diffs)

**Added in 5.4**
- production_id
- unit_concept_id
- unit_source_concept_id
- unit_source_value

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- device_exposure_id: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=SubNot Stable between Data Refreshes | 5.4=Sub Not Stable between Data Refreshes

### visit_occurrence (8 diffs)

**Added in 5.4**
- discharged_to_concept_id
- discharged_to_source_value

**Removed in 5.4** (present in 5.3 only)
- discharge_to_concept_id
- discharge_to_source_value
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- preceding_visit_occurrence_id: phi
  - phi: 5.3=(blank) | 5.4=Yes

### measurement (7 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- modifier_of_event_id
- modifier_of_field_concept_id
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- measurement_source_value: phi
  - phi: 5.3=Yes | 5.4=(blank)
- measurement_time: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=Null | 5.4=(blank)

### observation (7 diffs)

**Added in 5.4**
- obs_event_field_concept_id
- observation_event_id
- value_source_value

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- observation_source_value: phi, phi_scrubbing_operation
  - phi: 5.3=Yes | 5.4=(blank)
  - phi_scrubbing_operation: 5.3=TiDE | 5.4=(blank)

### condition_occurrence (6 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- provider_id: phi
  - phi: 5.3=(blank) | 5.4=Yes
- visit_detail_id: phi
  - phi: 5.3=(blank) | 5.4=Yes
- visit_occurrence_id: phi
  - phi: 5.3=(blank) | 5.4=Yes

### person (6 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- care_site_id: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=Sub with Stable between Data Refreshes | 5.4=(blank)
- person_source_value: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=Sub | 5.4=Del
- provider_id: phi
  - phi: 5.3=(blank) | 5.4=Yes

### image_occurrence (5 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- source_flag (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- anatomic_site_source_value: phi
  - phi: 5.3=Yes | 5.4=(blank)
- modality_source_value: phi
  - phi: 5.3=Yes | 5.4=(blank)

### note (5 diffs)

**Added in 5.4**
- note_event_field_concept_id
- note_event_id

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

**Changed** (same field, different metadata)
- note_source_value: phi_scrubbing_operation
  - phi_scrubbing_operation: 5.3=Sub | 5.4=(blank)

### procedure_occurrence (5 diffs)

**Added in 5.4**
- procedure_end_date
- procedure_end_datetime

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### drug_strength (4 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row _id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)
- valid_end_date
- valid_start_date

### cdm_source (3 diffs)

**Added in 5.4**
- cdm_version_concept_id

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### condition_era (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### death (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### drug_era (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### drug_exposure (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### fact_relationship (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id
- trace_id
- unit_id

### observation_period (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### provider (3 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)
- unit_id (Stanford construct for traceability)

### concept (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### concept_ancestor (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### concept_class (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### concept_relationship (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id
- load_table_id

### concept_synonym (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### domain (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id
- load_table_id

### metadata (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table
- unit_id

### payer_plan_period (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_table_id (Stanford construct for traceability)
- trace_id (Stanford construct for traceability)

### relationship (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

### vocabulary (2 diffs)

**Removed in 5.4** (present in 5.3 only)
- load_row_id (Stanford construct for traceability)
- load_table_id (Stanford construct for traceability)

