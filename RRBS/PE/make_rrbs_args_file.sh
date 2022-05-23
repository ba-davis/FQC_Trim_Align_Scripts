#!/bin/bash

# input: dir: path to raw files

# use ./make_rrbs_args_file.sh dir

# PE (assumes R2 file is named exactly as R1 file except "R2" instead of "R1")

for i in $1/*_R1_*.fastq.gz;
do
    file=${i##*/}
    file2=${file/_R1_/_R2_}
    name=${file/_R1*/}
    #t_file1=
    #t_file2=
    #t_file=${file/.fastq.gz/_trimmed.fq.gz}
    #b_file=${t_file/.fq.gz/_bismark_bt2.bam}
    echo $file:$file2 >> args_file
    #echo $file:$t_file:$b_file >> args_file;
done
