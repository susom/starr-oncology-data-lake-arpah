--------------------------------------------------------------------------
-- this query generates tb patients who had philips from arpah-cohort --
--------------------------------------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_dev.@oncology_temp.onc_all__cancer_flags`),
philips_mtb_pat_diag_orders as (select * from `@oncology_prod.@oncology_philips_raw.philips_mtb_pat_diag_orders`),
philips_patients as (
    select distinct
        if(
            length(p.patientdata_mrn) <= 8,
            lpad(p.patientdata_mrn, 8, '0'),
            lpad(p.patientdata_mrn, 10, '0')
        ) as cleaned_mrn,
        cast(p.patientdata_birthdate as date format 'yyyy-mm-dd') birth_date,

    from philips_mtb_pat_diag_orders p
),
tumor_board_patients AS (
select person_source_value from all_flag
where tumor_board_encounter_flag = 1
)
select count(distinct person.person_source_value) patient_count
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join philips_patients pp on tb.person_source_value = concat(pp.cleaned_mrn, ' | ', pp.birth_date)
