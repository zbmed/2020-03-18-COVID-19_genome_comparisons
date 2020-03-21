main(){
    readonly INPUT_FILE=../../data/2020-03-20-genome_sequences_from_NCBI/SARS-CoV-2_sequences.fasta
    readonly OUTPUT_FOLDER=output
    readonly MIN_LENGTH=29000
    readonly THREADS=24
    readonly FILTERED_SEQ_FASTA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}.fasta
    readonly OUTPUT_MUSCLE_MSA_AFA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_MUSCLE.afa
    readonly OUTPUT_MUSCLE_SA_HTML=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_MUSCLE.html
    readonly OUTPUT_CLUSTALO_FASTA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_clustal_omega.fasta
    readonly OUTPUT_KALIGN_FASTA=${OUTPUT_FOLDER}/SARS-CoV-2_sequences_above_${MIN_LENGTH}_MSA_kalign.fasta


    generate_folders
    remove_short_sequences
    log_muscle_version
    log_kalign_version
    log_clustalo_version
    # run_msa_with_muscle    # Stopped as running very long
    # run_msa_with_clustal_omega # Stopped as running very long
    run_msa_with_kalign
}

generate_folders(){
    mkdir -p ${OUTPUT_FOLDER}
}

remove_short_sequences(){
    python3.7 bin/remove_short_sequences.py \
	--input ${INPUT_FILE} \
	--output ${FILTERED_SEQ_FASTA} \
	--min_length ${MIN_LENGTH}
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
	-in ${FILTERED_SEQ_FASTA} \
	-out ${OUTPUT_MSA_AFA} \
	-htmlout ${OUTPUT_MUSCLE_SA_HTML}
}

run_msa_with_clustal_omega(){
    clustalo \
    	--force \
    	--threads ${THREADS} \
    	-i ${FILTERED_SEQ_FASTA} \
    	-o ${OUTPUT_CLUSTALO_FASTA}
}

run_msa_with_kalign(){
    kalign \
    	-input ${FILTERED_SEQ_FASTA} \
    	-output ${OUTPUT_KALIGN_FASTA} \
	-format fasta
}


main
