#!/bin/bash

## Based on https://github.com/macs3-project/MACS

# To run this script, do 
# qsub -t 1-n submit_macs2.sh CONFIG IDS
#
#$ -N macs2
#$ -j y
#$ -S /bin/bash
#$ -cwd
#$ -l h_vmem=12G
#$ -l h_rt=2:00:00
#$ -pe sharedmem 12

CONFIG=$1
IDS=$2
BAM_DIR=$3
OUTPUT_DIR=$4
THRESHOLD=$5

source $CONFIG

unset MODULEPATH
. /etc/profile.d/modules.sh

module load igmm/apps/MACS2/2.1.1  

SAMPLE_ID=`head -n $SGE_TASK_ID $IDS | tail -n 1 | cut -f 1`
CHIP_BAM=`head -n $SGE_TASK_ID $IDS | tail -n 1 | cut -f 2`
INPUT_BAM=`head -n $SGE_TASK_ID $IDS | tail -n 1 | cut -f 3`

cd $OUTPUT_DIR

## Change -g according to species under study

macs2 callpeak \
    -t $BAM_DIR/${CHIP_BAM} \
    -c $BAM_DIR/${INPUT_BAM} \
    -n ${SAMPLE_ID}_q${THRESHOLD} \
    -q 1e-${THRESHOLD} \
    -g hs

    
    
