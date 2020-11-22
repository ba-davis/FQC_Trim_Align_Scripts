#!/bin/bash

# input: dir: path to raw files

# use ./make_rrbs_args_file.sh dir


for i in $1/*.fastq.gz;
do
    file=${i##*/}
    t_file=${file/.fastq.gz/_trimmed.fq.gz}
    b_file=${t_file/.fq.gz/_bismark_bt2.bam}
    echo $file:$t_file:$b_file >> args_file;
done
