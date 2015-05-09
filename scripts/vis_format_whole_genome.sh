#!/bin/bash

## set paths
cadd_directory=

## move to CADD folder
cd $cadd_directory
mkdir chromosome_files
## load tabix
module load tabix

## extract 10 regions from chromosome 1
tabix whole_genome_SNVs.tsv.gz 1 > chromosome_files/chr1_0
tabix whole_genome_SNVs.tsv.gz 2 > chromosome_files/chr2_0
tabix whole_genome_SNVs.tsv.gz 3 > chromosome_files/chr3_0
tabix whole_genome_SNVs.tsv.gz 4 > chromosome_files/chr4_0
tabix whole_genome_SNVs.tsv.gz 5 > chromosome_files/chr5_0
tabix whole_genome_SNVs.tsv.gz 6 > chromosome_files/chr6_0
tabix whole_genome_SNVs.tsv.gz 7 > chromosome_files/chr7_0
tabix whole_genome_SNVs.tsv.gz 8 > chromosome_files/chr8_0
tabix whole_genome_SNVs.tsv.gz 9 > chromosome_files/chr9_0
tabix whole_genome_SNVs.tsv.gz 10 > chromosome_files/chr10_0
tabix whole_genome_SNVs.tsv.gz 11 > chromosome_files/chr11_0
tabix whole_genome_SNVs.tsv.gz 12 > chromosome_files/chr12_0
tabix whole_genome_SNVs.tsv.gz 13 > chromosome_files/chr13_0
tabix whole_genome_SNVs.tsv.gz 14 > chromosome_files/chr14_0
tabix whole_genome_SNVs.tsv.gz 15 > chromosome_files/chr15_0
tabix whole_genome_SNVs.tsv.gz 16 > chromosome_files/chr16_0
tabix whole_genome_SNVs.tsv.gz 17 > chromosome_files/chr17_0
tabix whole_genome_SNVs.tsv.gz 18 > chromosome_files/chr18_0
tabix whole_genome_SNVs.tsv.gz 19 > chromosome_files/chr19_0
tabix whole_genome_SNVs.tsv.gz 20 > chromosome_files/chr20_0
tabix whole_genome_SNVs.tsv.gz 21 > chromosome_files/chr21_0
tabix whole_genome_SNVs.tsv.gz 22 > chromosome_files/chr22_0
tabix whole_genome_SNVs.tsv.gz X > chromosome_files/chrX_0
tabix whole_genome_SNVs.tsv.gz Y > chromosome_files/chrY_0

## format for plotting
for file in chromosome_files/*; do \
	cut -f 6 $file | paste -d"\t" - - - | sed -e 's/[[:space:]]*$//' | awk ' {split( $0, a, " " ); asort( a ); for( i = 1; i <= length(a); i++ ) printf( "%s ", a[i] ); printf( "\n" ); }' > $file\_scores;
	cut -f 2 $file | awk 'NR % 3 == 0' > $file\_pos;
	paste -d " " $file\_pos $file\_scores > ${file}.tsv;
	sed -i '1s/^/P A B C\n/' ${file}.tsv;
 done

exit 0
