#!/bin/bash

#This script is to download/convert SRR to fastq files, given a txt file containing accession numbers. Make sure you know if samples are paired or singles
#To run this script, do qsub <script> txt.file

#$ -cwd
#$ -N SRR_to_fastq
#$ -j y
#$ -S /bin/bash
#$ -l h_vmem=8G
#$ -l h_rt=120:00:00

# Initialise the modules framework
. /etc/profile.d/modules.sh

#Load SRA toolkit
module load igmm/apps/sratoolkit/2.8.2-1

FILES=$1
SRR=`head -n $SGE_TASK_ID $FILES | tail -n 1`
OUTDIR=/exports/igmm/eddie/Glioblastoma-WGS/ChIP-seq/H3K27ac-seq_GBM/reads/Single_end_reads

#Based on tips here https://edwards.sdsu.edu/research/fastq-dump/
#And changes if paired/single end data.
cd $OUTDIR
fastq-dump --origfmt --gzip --skip-technical --outdir $OUTDIR $SRR
rm -rf /home/mhamdan/ncbi/public/sra/${SRR}*

#To convert SRR/ERR files to fastq files and then gzip them.
##cat $ERR | xargs fastq-dump --outdir ../fastq --gzip --skip-technical -split-files -clip
#cat $1 | head -1 | xargs fastq-dump -X 1 -Z

#or if already downloaded
##fastq-dump --outdir fastq --gzip --skip-technical -split-files -clip -A SRA/*

#Try this one if not downloaded
#cat $ERR | xargs prefetch --max-size 100000000
#mkdir SRAtofastq
#for sraFile in *; do
#echo "Extracting fastq from "${sraFile};
#fastq-dump --origfmt --gzip --outdir ../G523fastq ${sraFile};
#done
