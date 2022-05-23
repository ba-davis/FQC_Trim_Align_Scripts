#!/bin/bash

#-----------------#
# INPUT VARIABLES #
#-----------------#
# path to raw fastq files (for trimming)
inpath=$1
# path to folder containing STAR indices for reference genome
genome=$2
# path to gtf file for reference genome annotation
gtf=$3

# current directory (scripts directory)
dir=$(pwd)

# Make args_file using script and input path to raw files
./make_rnaseq_args_file.sh $inpath
cat args_file
# store args_file as variable
args_file=$dir/args_file
# store number of files/jobs
n_files=$(wc -l args_file | cut -f1 -d ' ')

echo "${n_files}"

# make output directories
mkdir -p ../slurm_debug
mkdir -p ../data/FastQC
mkdir -p ../data/FastQC/raw
mkdir -p ../data/FastQC/trimmed
mkdir -p ../data/trimming
mkdir -p ../data/trimming/unpaired
mkdir -p ../data/star

# execute the sbatch script
sbatch -a 1-"$n_files" rnaseq_sbatch_script.sh $inpath $genome $gtf

#wait

# run MultiQC on the FastQC reports for raw and trimmed files
#multiqc ../data/FastQC/raw
#multiqc ../data/FastQC/trimmed

# collect the trimmomatic PE stats
#collect_trimmomatic_pe_stats.sh $inpath ../slurm_debug
