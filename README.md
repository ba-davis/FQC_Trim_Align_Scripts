# FQC_Trim_Align_Scripts

This repository contains bash scripts to handle the beginning stages of analysis for sequencing projects with Fastq files.

This primarily includes:
1. FastQC on raw reads
2. Trimming low quality bases and adapters
3. FastQC on trimmed reads
4. Aligning trimmed reads to a reference genome

These scripts also make use of SLURM and sbatch to run in parallel.
