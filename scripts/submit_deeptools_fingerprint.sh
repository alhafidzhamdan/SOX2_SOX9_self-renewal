
#!/bin/bash

# To run this script, do 
# qsub -t 1-n submit_deeptools_fingerprint.sh CONFIG IDS CHIP BATCH
#
#$ -N plotFingerprint
#$ -j y
#$ -S /bin/bash
#$ -cwd
#$ -l h_vmem=6G
#$ -l h_rt=72:00:00
#$ -pe sharedmem 6 

## QC on filtered bam files using deeptools
## Based on https://deeptools.readthedocs.io/en/develop/index.html
## Generate various metrics useful for quality control.

CONFIG=$1
IDS=$2
BAM_DIR=$3
OUTPUT_DIR=$4

SAMPLE_ID=`head -n $SGE_TASK_ID $IDS | tail -n 1`

source $CONFIG

## Deeptools need python 3.65
export PATH=/exports/igmm/eddie/Glioblastoma-WGS/anaconda/envs/py365/bin:$PATH

CHIP_BAM=$BAM_DIR/${SAMPLE_ID}_H3K27AC.final.bam
INPUT_BAM=$BAM_DIR/${SAMPLE_ID}_INPUT.final.bam

cd $OUTPUT_DIR

echo "Plotting fingerprint for ${SAMPLE_ID}..."
plotFingerprint \
    --bamfiles $CHIP_BAM $INPUT \
    --plotFile ${SAMPLE_ID}_H3K27ac.fingerprint.png \
    --minMappingQuality 30 --skipZeros \
    --smartLabels --extendReads 150 \
    --region 1 --numberOfSamples 50000 
      
    

