#!/bin/bash

#$ -N ROSE
#$ -j y
#$ -S /bin/bash
#$ -cwd
#$ -l h_vmem=16G
#$ -pe sharedmem 16
#$ -l h_rt=60:00:00

CONFIG=$1
IDS=$2

source $CONFIG

### ROSE: Rank Ordering of Super-Enhancers
### Based on https://github.com/stjude/ROSE

NARROWPEAK=`head -n $SGE_TASK_ID $IDS | cut -f 1| tail -n 1`
BAMFILE=`head -n $SGE_TASK_ID $IDS | cut -f 2| tail -n 1`
CONTROL=`head -n $SGE_TASK_ID $IDS | cut -f 3| tail -n 1`
INPUT_DIR=/exports/igmm/eddie/Glioblastoma-WGS/ChIP-seq/H3K27ac-seq_GBM/ROSE/INPUT
OUTPUT_DIR=/exports/igmm/eddie/Glioblastoma-WGS/ChIP-seq/H3K27ac-seq_GBM/ROSE/OUTPUT
ANNOTATION=/exports/igmm/eddie/Glioblastoma-WGS/scripts/rose/annotation/hg38_refseq.ucsc

PATHTO=/exports/igmm/eddie/Glioblastoma-WGS/scripts/ROSE
PYTHONPATH=$PATHTO/lib
export PYTHONPATH
export PATH=$PATH:$PATHTO/bin

cd $INPUT_DIR

if [ ! -f ${NARROWPEAK%_peaks.narrowPeak.gz}.gff ]; then
    zcat $NARROWPEAK | sort -k1,1 -k2,2n | awk -F\\t '{print $1 "\t" NR "\t\t" $2 "\t" $3 "\t\t.\t\t" NR}' > ${NARROWPEAK%_peaks.narrowPeak.gz}.gff
else 
    echo "Processed gff file already exist."
fi

if [ ! -f $OUTPUT_DIR/${NARROWPEAK%_peaks.narrowPeak.gz}_Plot_points.png ]; then
    ROSE_main.py -g hg38 -i ${NARROWPEAK%_peaks.narrowPeak.gz}.gff -r $BAMFILE -c $CONTROL --custom $ANNOTATION -o $OUTPUT_DIR
fi












