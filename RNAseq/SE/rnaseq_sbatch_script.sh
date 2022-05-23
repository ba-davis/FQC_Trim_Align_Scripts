#!/bin/bash

#SBATCH -p exacloud                       # partition (queue)
#SBATCH -N 1                              # number of nodes
#SBATCH -n 8                              # number of cores
#SBATCH --mem 172000                      # memory pool for all cores
#SBATCH -t 0-24:00                        # time (D-HH:MM)
#SBATCH -o ../slurm_debug/rnaseq%A_%a.out # Standard output
#SBATCH -e ../slurm_debug/rnaseq%A_%a.err # Standard error

source activate /home/groups/hoolock2/u0/bd/bin/miniconda3/envs/RNAseq

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID

#-----------------#
# INPUT VARIABLES #
#-----------------#
# path to raw fastq files (for trimming)
inpath=$1
# path to folder containing STAR indices for reference genome
genome=$2
# path to gtf file for reference genome annotation
gtf=$3

#----------------------#
# HARD CODED VARIABLES #
#----------------------#
# current directory (scripts directory)
dir=$(pwd)

outdir_fqc="../data/FastQC/raw"             # outdir path for FastQC files
outdir_fqc_trimmed="../data/FastQC/trimmed" # outdir path for FastQC on trimmed files
outdir_trim="../data/trimming"              # outdir path for trimmed files
outdir_star="../data/star"                  # outdir path for star alignment files

# set path to arguments file
# input path to raw files
# example: ./make_rrbs_args_file.sh /home/groups/hoolock/u0/Epigenetics_Core_rawdata/ECP34
args_file=$dir/args_file

# set variable "ARGS" to be the output of the correct line from args_file (matches SLURM_ARRAY_TASK_ID)
ARGS=`head -$SLURM_ARRAY_TASK_ID $args_file | tail -1`
# set variables based on the output of the line ARGS
IFS=: read RAWFILE1 BASENAME TRIMFILE1 <<< $ARGS

# Run FastQC on Raw Files
fastqc -o $outdir_fqc $inpath/$RAWFILE1

# Run Trimmomatic on each pair of files
trimmomatic \
  SE \
  -phred33 \
  $inpath/$RAWFILE1 \
  $outdir_trim/$BASENAME.trimmed.fastq.gz \
  ILLUMINACLIP:/home/groups/hoolock2/u0/bd/bin/miniconda3/envs/RNAseq/share/trimmomatic-0.39-1/adapters/TruSeq3-PE-2.fa:2:30:10:8:true \
  LEADING:3 \
  TRAILING:3 \
  SLIDINGWINDOW:4:15 \
  MINLEN:36

# Run FastQC on Trimmed Files
fastqc -o $outdir_fqc_trimmed $outdir_trim/$TRIMFILE1
fastqc -o $outdir_fqc_trimmed $outdir_trim/$TRIMFILE2

# Align trimmed files to reference genome with STAR
STAR \
  --runThreadN 8 \
  --genomeDir $genome \
  --readFilesIn $outdir_trim/$TRIMFILE1 \
  --readFilesCommand zcat \
  --sjdbGTFfile $gtf \
  --outFileNamePrefix $outdir_star/$BASENAME.star. \
  --outSAMstrandField intronMotif \
  --outSAMtype BAM SortedByCoordinate \
  --outFilterIntronMotifs RemoveNoncanonicalUnannotated \
  --quantMode GeneCounts \
  --twopassMode Basic \
  --outReadsUnmapped Fastx

# Collect summary statistics
#./collect_rnaseq_stats.sh $inpath

# Print Tool Versions to output
echo "---TOOL-VERSIONS---"
echo "$(fastqc --version)"
echo "$(multiqc --version)"
echo "Trimmomatic $(trimmomatic -version)"
echo "STAR $(STAR --version)"
echo "STAR genome indices: " $genome
echo "STAR annotation gtf: " $gtf
