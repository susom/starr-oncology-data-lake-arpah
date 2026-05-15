-- Count of unique patients by document_information_type
-- Dataset: epic_media_server_documents.pdfs_arpah_cancer_patients_irb76049_aug2025

select 
    document_information_type, 
    count(distinct pat_id) as unique_patient_count
from som-rit-phi-oncology-prod.epic_media_server_documents.pdfs_arpah_cancer_patients_irb76049_aug2025
group by 1 
order by 2 desc;