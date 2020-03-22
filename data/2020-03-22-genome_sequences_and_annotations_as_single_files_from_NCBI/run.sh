#!/usr/bin/env bash

set -o errexit # exit if an error occurs

main(){
    readonly OUTPUT_FOLDER=output
    readonly FASTA_FOLDER=${OUTPUT_FOLDER}/fasta
    readonly GFF3_FOLDER=${OUTPUT_FOLDER}/gff3
    readonly ID_XML_FILE=${OUTPUT_FOLDER}/SARS-CoV-2_seq_ids.xml

    create_folders
    search_and_store_ids
    dowload_fasta_and_gff3_files
}

create_folders(){
    mkdir -p \
	  ${OUTPUT_FOLDER} \
	  ${FASTA_FOLDER} \
	  ${GFF_FOLDER}
}

search_and_store_ids(){
    # Search with the term to get ID
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nuccore&term=SARS-CoV-2&retmax=1000" \
	 > ${ID_XML_FILE}
}

dowload_fasta_and_gff3_files(){    
    ID_LIST=$(grep "^<Id>" ${ID_XML_FILE} | sed -e "s/<Id>//" -e "s/<\/Id>//" | tr "\n" " ")
    for SEQ_ID in ${ID_LIST}
    do
	echo ${SEQ_ID}
	curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${SEQ_ID}&rettype=fasta" \
	     > ${FASTA_FOLDER}/${SEQ_ID}.fasta

	curl "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=gff3&id=${SEQ_ID}&conwithfeat=on&withparts=on" \
	     > ${GFF3_FOLDER}/${SEQ_ID}.gff
    done
}

main
