#!/bin/bash

#SBATCH -p exacloud                     # partition (queue)
#SBATCH -N 1                            # number of nodes
#SBATCH -n 8                            # number of cores
#SBATCH --mem 172000                    # memory pool for all cores
#SBATCH -t 0-24:00                      # time (D-HH:MM)
#SBATCH -o ../slurm_debug/rrbs%A_%a.out # Standard output
#SBATCH -e ../slurm_debug/rrbs%A_%a.err # Standard error

source activate test_BS_seq

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID

#-----------------#
# INPUT VARIABLES #
#-----------------#
# path to raw fastq files (for trimming)
inpath=$1
# reference genome folder path
genome=$2

#----------------------#
# HARD CODED VARIABLES #
#----------------------#
# current directory (scripts directory)
dir=$(pwd)

outdir_fqc="../data/FastQC/raw"   # outdir path for FastQC files
outdir_trim="../data/trimming"    # outdir path for trimmed files
outdir_bis="../data/bismark_aln"  # outdir path for bismark alignment files
outdir_ext="../data/meth_extract" # outdir path for methylation extractor

# set path to arguments file (use script /home/groups/hoolock/u1/bd/my_scripts/make_rrbs_args_file.sh)
# input path to raw files
# example: ./make_rrbs_args_file.sh /home/groups/hoolock/u0/Epigenetics_Core_rawdata/ECP34
args_file=$dir/args_file

# set variable "ARGS" to be the output of the correct line from args_file (matches SLURM_ARRAY_TASK_ID)
ARGS=`head -$SLURM_ARRAY_TASK_ID $args_file | tail -1`
# set variables based on the output of the line ARGS
IFS=: read RAWFILE TRIMMEDFILE BAMFILE <<< $ARGS

# Run FastQC on Raw Files
fastqc -o $outdir_fqc $inpath/$RAWFILE

# Run TrimGalore on raw files and fastqc on trimmed files
trim_galore -o $outdir_trim  --fastqc_args "--outdir /home/groups/hoolock2/u0/bd/Projects/ECP51/fqc_align/fastqc/trimmed" --rrbs $inpath/$RAWFILE

# Run Bismark on the trimmed files
bismark \
-p 4 \
$genome \
$outdir_trim/$TRIMMEDFILE \
-o $outdir_bis \
--bam

# Run methylation extractor on the bam files
bismark_methylation_extractor \
-s \
--comprehensive \
--merge_non_CpG \
--multicore 3 \
-o $outdir_ext \
--gzip \
--bedGraph \
--cytosine_report \
--genome_folder $genome \
$outdir_bis/$BAMFILE
