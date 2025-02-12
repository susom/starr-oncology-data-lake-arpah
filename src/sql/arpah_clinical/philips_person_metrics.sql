with
philips_mtb_pat_diag_orders as (select * from `som-rit-phi-oncology-prod.oncology_philips_raw.philips_mtb_pat_diag_orders`),
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`),
philips_patients as (
    select distinct
        if(
            length(p.patientdata_mrn) <= 8,
            lpad(p.patientdata_mrn, 8, '0'),
            lpad(p.patientdata_mrn, 10, '0')
        ) as cleaned_mrn,
        cast(p.patientdata_birthdate as date format 'yyyy-mm-dd') birth_date,
    from philips_mtb_pat_diag_orders p
)
select
  count(distinct person_source_value) patient_count
  from
  philips_patients p
inner join person on person.person_source_value = concat(cleaned_mrn, ' | ', birth_date)