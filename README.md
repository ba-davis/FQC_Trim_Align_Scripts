# FQC_Trim_Align_Scripts

This repository contains bash scripts to handle the beginning stages of analysis for sequencing projects with Fastq files.

This primarily includes:
1. FastQC on raw reads
2. Trimming low quality bases and adapters
3. FastQC on trimmed reads
4. Aligning trimmed reads to a reference genome

These scripts also make use of SLURM and sbatch to run in parallel.

## RNAseq
For RNAseq projects, Trimmomatic is used as the trimming software and STAR is used as the aligner.
The scripts include:
1. make_rnaseq_args_file.sh - produces the "args_file" to be referenced during sbatch SLURM submission
2. rnaseq_sbatch_script.sh - contains the SLURM sbatch variables, references args_file, contains code for executing FastQC, trimming, and aligning, outputs tool versions
3. submit_script_rnaseq.sh - references and executes the above two scripts to submit jobs via SLURM with sbatch
  - takes as input in this order: path to folder containing raw fastq files, path to folder containing STAR indices for reference genome, path to gtf file for reference genome annotation
  - example of execution:

./submit_script_rnaseq.sh \
  /path/to/raw_files/dir \
  /path/to/reference_genome/star \
  /path/to/annotation_file.gtf


## RRBS
For RRBS (Reduced Representation Bisulfite Sequencing) projects, trimGalore is used as the trimming software and Bismark is used as the aligner.
The scripts include:
1. make_rrbs_args_file.sh - produces the "args_file" to be referenced during sbatch SLURM submission
2. rrbs_sbatch_script.sh - contains the SLURM sbatch variables, references args_file, contains code for executing FastQC, trimming, and aligning
3. submit_script.sh - references and executes the above two scripts to submit jobs via SLURM with sbatch

TODO
clean up input variables for RRBS scripts (make command line inputs)
fix RRBS trimmed fqc output directory (set as variable)
