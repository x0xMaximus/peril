#!/bin/bash

## set paths
cadd_directory=

## move to CADD folder
cd $cadd_directory
mkdir chromosome_files
## load tabix
module load tabix

## extract 10 regions from chromosome 1
tabix whole_genome_SNVs.tsv.gz 1:100,000,001-100,008,000 > chromosome_files/chr1_0
tabix whole_genome_SNVs.tsv.gz 1:100,008,001-100,016,000 > chromosome_files/chr1_1
tabix whole_genome_SNVs.tsv.gz 1:100,016,001-100,024,000 > chromosome_files/chr1_2
tabix whole_genome_SNVs.tsv.gz 1:100,024,001-100,032,000 > chromosome_files/chr1_3
tabix whole_genome_SNVs.tsv.gz 1:100,032,001-100,040,000 > chromosome_files/chr1_4
tabix whole_genome_SNVs.tsv.gz 1:100,040,001-100,048,000 > chromosome_files/chr1_5
tabix whole_genome_SNVs.tsv.gz 1:100,048,001-100,056,000 > chromosome_files/chr1_6
tabix whole_genome_SNVs.tsv.gz 1:100,056,001-100,064,000 > chromosome_files/chr1_7
tabix whole_genome_SNVs.tsv.gz 1:100,064,001-100,072,000 > chromosome_files/chr1_8
tabix whole_genome_SNVs.tsv.gz 1:100,072,001-100,080,000 > chromosome_files/chr1_9

## extract 1 region from all the others
tabix whole_genome_SNVs.tsv.gz 2:100,000,001-100,008,000 > chromosome_files/chr2_0
tabix whole_genome_SNVs.tsv.gz 3:100,000,001-100,008,000 > chromosome_files/chr3_0
tabix whole_genome_SNVs.tsv.gz 4:100,000,001-100,008,000 > chromosome_files/chr4_0
tabix whole_genome_SNVs.tsv.gz 5:100,000,001-100,008,000 > chromosome_files/chr5_0
tabix whole_genome_SNVs.tsv.gz 6:50,000,001-50,008,000 > chromosome_files/chr6_0
tabix whole_genome_SNVs.tsv.gz 7:50,000,001-50,008,000 > chromosome_files/chr7_0
tabix whole_genome_SNVs.tsv.gz 8:50,000,001-50,008,000 > chromosome_files/chr8_0
tabix whole_genome_SNVs.tsv.gz 9:50,000,001-50,008,000 > chromosome_files/chr9_0
tabix whole_genome_SNVs.tsv.gz 10:50,000,001-50,008,000 > chromosome_files/chr10_0
tabix whole_genome_SNVs.tsv.gz 11:50,000,001-50,008,000 > chromosome_files/chr11_0
tabix whole_genome_SNVs.tsv.gz 12:50,000,001-50,008,000 > chromosome_files/chr12_0
tabix whole_genome_SNVs.tsv.gz 13:50,000,001-50,008,000 > chromosome_files/chr13_0
tabix whole_genome_SNVs.tsv.gz 14:50,000,001-50,008,000 > chromosome_files/chr14_0
tabix whole_genome_SNVs.tsv.gz 15:50,000,001-50,008,000 > chromosome_files/chr15_0
tabix whole_genome_SNVs.tsv.gz 16:50,000,001-50,008,000 > chromosome_files/chr16_0
tabix whole_genome_SNVs.tsv.gz 17:30,000,001-30,008,000 > chromosome_files/chr17_0
tabix whole_genome_SNVs.tsv.gz 18:30,000,001-30,008,000 > chromosome_files/chr18_0
tabix whole_genome_SNVs.tsv.gz 19:30,000,001-30,008,000 > chromosome_files/chr19_0
tabix whole_genome_SNVs.tsv.gz 20:30,000,001-30,008,000 > chromosome_files/chr20_0
tabix whole_genome_SNVs.tsv.gz 21:30,000,001-30,008,000 > chromosome_files/chr21_0
tabix whole_genome_SNVs.tsv.gz 22:30,000,001-30,008,000 > chromosome_files/chr22_0
tabix whole_genome_SNVs.tsv.gz X:50,000,001-50,008,000 > chromosome_files/chrX_0
tabix whole_genome_SNVs.tsv.gz Y:50,000,001-50,008,000 > chromosome_files/chrY_0

## format for plotting
for file in chromosome_files/*; do \
	cut -f 6 $file | paste -d"\t" - - - | sed -e 's/[[:space:]]*$//' | awk ' {split( $0, a, " " ); asort( a ); for( i = 1; i <= length(a); i++ ) printf( "%s ", a[i] ); printf( "\n" ); }' > $file\_scores;
	cut -f 2 $file | awk 'NR % 3 == 0' > $file\_pos;
	paste -d " " $file\_pos $file\_scores > ${file}.tsv;
 done

exit 0
