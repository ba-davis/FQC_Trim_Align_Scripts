#!/bin/bash

# input: dir: path to raw files (paired end)

# use ./make_rnaseq_args_file.sh dir

# PE (assumes R2 file is named exactly as R1 file except "R2" instead of "R1") 
for i in $1/*_R1_*.fastq.gz;
do
    file=${i##*/}
    file2=${file/_R1_/_R2_}
    name=${file/_R1*/}
    trimmed1=out_paired_R1_$name.fastq.gz
    trimmed2=out_paired_R2_$name.fastq.gz
    echo $file:$file2:$name:$trimmed1:$trimmed2 >> args_file
done
