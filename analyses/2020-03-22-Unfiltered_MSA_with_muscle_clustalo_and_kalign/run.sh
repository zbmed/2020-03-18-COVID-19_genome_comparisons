main(){
    readonly INPUT_FILE=../../data/2020-03-20-genome_sequences_from_NCBI/SARS-CoV-2_sequences.fasta
    readonly OUTPUT_FOLDER=output
    readonly MIN_LENGTH=29000
    readonly THREADS=24
    readonly OUTPUT_MUSCLE_MSA_AFA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_MUSCLE.afa
    readonly OUTPUT_MUSCLE_SA_HTML=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_MUSCLE.html
    readonly OUTPUT_CLUSTALO_FASTA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_clustal_omega.fasta
    readonly OUTPUT_KALIGN_FASTA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_kalign.fasta
    readonly OUTPUT_KALIGN_CLEANED_NAMES_FASTA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_kalign_cleaned_name.fasta
    readonly OUTPUT_KALIGN_RAXML_TREE_PREFIX=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_kalign_raxml_tree
    readonly OUTPUT_KALIGN_RAXML_ERROR=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_kalign_raxml_error_msg.txt

    generate_folders
    log_muscle_version
    log_kalign_version
    log_clustalo_version
    run_msa_with_muscle # Fails with Segmentation fault
    run_msa_with_clustal_omega
    run_msa_with_kalign
    clean_taxon_names
    create_tree_with_raxml_ng # Fails
}

generate_folders(){
    mkdir -p ${OUTPUT_FOLDER}
}

log_muscle_version(){
    muscle -version > ${OUTPUT_FOLDER}/muscle_version.txt
}

log_clustalo_version(){
    clustalo --version > ${OUTPUT_FOLDER}/clustalo_version.txt
}

log_kalign_version(){
    kalign 2> /tmp/k
    grep version /tmp/k > ${OUTPUT_FOLDER}/kalign_version.txt
}

run_msa_with_muscle(){
    muscle \
	-in ${INPUT_FILE} \
	-out ${OUTPUT_MUSCLE_MSA_AFA}
}

run_msa_with_clustal_omega(){
    clustalo \
    	--force \
    	--threads ${THREADS} \
    	-i ${INPUT_FILE} \
    	-o ${OUTPUT_CLUSTALO_FASTA}
}

run_msa_with_kalign(){
    kalign \
    	-input ${INPUT_FILE} \
    	-output ${OUTPUT_KALIGN_FASTA} \
	-format fasta
}

clean_taxon_names(){

    # Required as raxml otherwise raises the error "ERROR: Following
    # taxon name contains invalid characters:"
    
    sed -e "s/\// /g" \
	-e "s/\(/ /g"\
	-e "s/\)/ /g"\	
	${OUTPUT_KALIGN_FASTA} \
	> ${OUTPUT_KALIGN_CLEANED_NAMES_FASTA}
}

create_tree_with_raxml_ng(){
    # Fails - see error message
    raxml-ng \
	--msa ${OUTPUT_KALIGN_CLEANED_NAMES_FASTA} \
	--prefix ${OUTPUT_KALIGN_TREE_PREFIX} \
	--threads 2 \
	--seed 1 \
	2> ${OUTPUT_KALIGN_RAXML_ERROR}
}

main
