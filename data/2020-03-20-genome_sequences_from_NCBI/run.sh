# Search with the term to get ID
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nuccore&term=SARS-CoV-2&retmax=1000" \
     > SARS-CoV-2_seq_ids.xml

# Extreact ID list 
ID_LIST=$(grep "^<Id>" SARS-CoV-2_seq_ids.xml | sed -e "s/<Id>//" -e "s/<\/Id>//" | tr "\n" ",")

# Retrieve sequnces in fast format
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${ID_LIST}&rettype=fasta" \
     > SARS-CoV-2_sequences.fasta
