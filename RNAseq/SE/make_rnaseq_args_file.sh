#!/bin/bash

# input: dir: path to raw files (single end)

# use ./make_rnaseq_args_file.sh dir

# SE
# assumes fastq files end in fastq.gz
# assumes fastq file names have _R1_ in them
for i in $1/*.fastq.gz;
do
    file=${i##*/}
    #file2=${file/_R1_/_R2_}
    name=${file/_R1*/}
    trimmed=$name.trimmed.fastq.gz
    #trimmed2=out_paired_R2_$name.fastq.gz
    echo $file:$name:$trimmed >> args_file
    #echo $file:$file2:$name:$trimmed1:$trimmed2 >> args_file
done
