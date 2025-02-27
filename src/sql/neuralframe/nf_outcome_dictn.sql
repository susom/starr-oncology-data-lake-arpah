------- 

with all_nf as (
select column_name from som-rit-phi-oncology-dev.fsh_fullfarnoosh_oncology_common.INFORMATION_SCHEMA.COLUMNS 
where table_name = 'onc_neuralframe_case_outcomes')
select * from all_nf
left join som-rit-phi-oncology-dev.oncology_neuralframe_raw.neuralframe_data_dictionary_2025_02_13 dict
on upper(all_nf.column_name)=upper(dict.fieldid)