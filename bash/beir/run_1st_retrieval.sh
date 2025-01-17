#!/bin/bash

# Ensure the input directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

input_dir="$1"

# Create necessary directories
output_dir="outputs/beir"
data_dir="datasets/beir"

mkdir -p "$output_dir" "$data_dir"

# Datasets to process
datasets=('trec-covid' 'scifact' 'scidocs' 'nfcorpus' 'fiqa' ) #'climate-fever' 'dbpedia-entity' 'fever'  'hotpotqa' 'msmarco' 'nq' 

# Iterate over datasets
for dataset in "${datasets[@]}"; do
    echo "Processing dataset: ${dataset}"

    dataset_output_dir="${output_dir}/${dataset}"
    mkdir -p "$dataset_output_dir"

    python -m tevatron.faiss_retriever \
        --query_reps "${input_dir}/${dataset}/original_query/qry.pt" \
        --passage_reps "${input_dir}/${dataset}/original_corpus/*.pt" \
        --depth 1000 \
        --batch_size -1 \
        --save_text \
        --save_ranking_to "${dataset_output_dir}/rank.tsv"
done
