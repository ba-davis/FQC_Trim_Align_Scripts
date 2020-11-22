#!/bin/bash

#-----------------#
# INPUT VARIABLES #
#-----------------#
# path to raw fastq files (for trimming)
inpath="/home/groups/hoolock2/u0/archive/Epigenetics_Core_rawdata/ECP53"
# reference genome folder path
genome="/home/groups/hoolock2/u0/genomes/ensembl/homo_sapiens/primary_assembly"

# current directory (scripts directory)
dir=$(pwd)

# Make RRBS args_file using script and input path to raw files
./make_rrbs_args_file.sh $inpath
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
mkdir -p ../data/bismark_aln
mkdir -p ../data/meth_extract

# execute the sbatch script
#echo 'sbatch rrbs_sbatch_script.sh "$inpath" "$genome" -a 1-"$n_files"'

#echo "sbatch rrbs_sbatch_script.sh $inpath $genome -a 1-${n_files}"

sbatch -a 1-"$n_files" rrbs_sbatch_script.sh $inpath $genome
