main(){
    readonly INPUT_FILE=../../data/2020-03-20-genome_sequences_from_NCBI/SARS-CoV-2_sequences.fasta
    readonly OUTPUT_FOLDER=output

    generate_folders
    generate_genome_size_report

}

generate_folders(){
    mkdir -p ${OUTPUT_FOLDER}
}

generate_genome_size_report(){
    python3.7 bin/genome_legnth_hist.py \
       --input ${INPUT_FILE} \
       --output_pdf ${OUTPUT_FOLDER}/length_distribution.pdf \
       --output_txt ${OUTPUT_FOLDER}/Report.txt
}

main
