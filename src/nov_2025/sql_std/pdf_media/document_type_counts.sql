-- Count of documents by document_information_type
-- Dataset: epic_media_server_documents.pdfs_arpah_cancer_patients_irb76049_aug2025

select 
    document_information_type, 
    count(*) as document_count
from som-rit-phi-oncology-prod.epic_media_server_documents.pdfs_arpah_cancer_patients_irb76049_aug2025
group by 1 
order by 2 desc;