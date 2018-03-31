#!/bin/bash

#SBATCH --job-name=tsonip45
#SBATCH --time=96:00:00
#SBATCH -p normal
#SBATCH --nodes=1
#SBATCH --mail-user=thinhdv@ntu.edu.vn
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finish

module load ddocent/2.24
echo "chi su dug cai nay trong truong hop ma thuc hien call SNP bi bao loi do cai phan cai tien cua Cbird"

CUTOFF=4
CUTOFF2=5

#Neu nhu chua co file mapped*bed thi tien hanh tao ra em no

if [ ! -f "mapped.$CUTOFF.$CUTOFF2.bed" ]; then
	echo "CreateIntervals"
	echo ""; echo `date` " recreating intervals again"
	bamToBed -i cat.$CUTOFF.$CUTOFF2-RRG.bam > map.$CUTOFF.$CUTOFF2.bed
	bedtools merge -i map.$CUTOFF.$CUTOFF2.bed > mapped.$CUTOFF.$CUTOFF2.bed
	rm map.$CUTOFF.$CUTOFF2.bed
	
	#Goi chuong trinh tao SNPs calling
	echo "da ton tai file mapped.*.bed"
	
	#SNPCalling
	DP=$(mawk '{print $4}' cov.$CUTOFF.$CUTOFF2.stats | sort -rn | perl -e '$d=.001;@l=<>;print $l[int($d*@l)]')
	CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/200}')

	echo `date` " Making the bed files"
	mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats |sort -V -k1,1 -k2,2 | mawk -v x1="$CUTOFF.$CUTOFF2" -v cutoff=$CC 'BEGIN{i=1} 
	{
		len=$3-$2;lc=len*$4;cov = cov + lc
		if ( cov < cutoff) {x="mapped."i"."x1".bed";print $1"\t"$2"\t"$3 > x}
		else {i=i+1; x="mapped."i"."x1".bed"; print $1"\t"$2"\t"$3 > x; cov=0}
	}' 
	#Creates a population file to use for more accurate genotype calling
	cut -f1 -d "_" namelist > p.$CUTOFF.$CUTOFF2
	paste namelist p.$CUTOFF.$CUTOFF2 > popmap.$CUTOFF.$CUTOFF2
	rm p.$CUTOFF.$CUTOFF2
	
	echo "Call SNPs with 10 cpu threads"	
	mv mapped.$CUTOFF.$CUTOFF2.bed mapped.$CUTOFF.$CUTOFF2
	
	ls mapped.*.bed | sed 's/mapped.//g' | sed 's/.bed//g' | shuf | parallel -j 10 --no-notice --delay 1 freebayes -L bamlist.$CUTOFF.$CUTOFF2.list -t mapped.{}.bed -v raw.{}.vcf -f reference.$CUTOFF.$CUTOFF2.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap.$CUTOFF.$CUTOFF2 -n 10
	
	echo "Processing vcf file and make Raw SNPs"	
	rm mapped.*.$CUTOFF.$CUTOFF2.bed 

	mv raw.1.$CUTOFF.$CUTOFF2.vcf raw.001.$CUTOFF.$CUTOFF2.vcf
	mv raw.2.$CUTOFF.$CUTOFF2.vcf raw.002.$CUTOFF.$CUTOFF2.vcf
	mv raw.3.$CUTOFF.$CUTOFF2.vcf raw.003.$CUTOFF.$CUTOFF2.vcf
	mv raw.4.$CUTOFF.$CUTOFF2.vcf raw.004.$CUTOFF.$CUTOFF2.vcf
	mv raw.5.$CUTOFF.$CUTOFF2.vcf raw.005.$CUTOFF.$CUTOFF2.vcf
	mv raw.6.$CUTOFF.$CUTOFF2.vcf raw.006.$CUTOFF.$CUTOFF2.vcf
	mv raw.7.$CUTOFF.$CUTOFF2.vcf raw.007.$CUTOFF.$CUTOFF2.vcf
	mv raw.8.$CUTOFF.$CUTOFF2.vcf raw.008.$CUTOFF.$CUTOFF2.vcf
	mv raw.9.$CUTOFF.$CUTOFF2.vcf raw.009.$CUTOFF.$CUTOFF2.vcf
	mv raw.10.$CUTOFF.$CUTOFF2.vcf raw.010.$CUTOFF.$CUTOFF2.vcf
	mv raw.11.$CUTOFF.$CUTOFF2.vcf raw.011.$CUTOFF.$CUTOFF2.vcf
	mv raw.12.$CUTOFF.$CUTOFF2.vcf raw.012.$CUTOFF.$CUTOFF2.vcf
	mv raw.13.$CUTOFF.$CUTOFF2.vcf raw.013.$CUTOFF.$CUTOFF2.vcf
	mv raw.14.$CUTOFF.$CUTOFF2.vcf raw.014.$CUTOFF.$CUTOFF2.vcf
	mv raw.15.$CUTOFF.$CUTOFF2.vcf raw.015.$CUTOFF.$CUTOFF2.vcf
	mv raw.16.$CUTOFF.$CUTOFF2.vcf raw.016.$CUTOFF.$CUTOFF2.vcf
	mv raw.17.$CUTOFF.$CUTOFF2.vcf raw.017.$CUTOFF.$CUTOFF2.vcf
	mv raw.18.$CUTOFF.$CUTOFF2.vcf raw.018.$CUTOFF.$CUTOFF2.vcf
	mv raw.19.$CUTOFF.$CUTOFF2.vcf raw.019.$CUTOFF.$CUTOFF2.vcf
	mv raw.20.$CUTOFF.$CUTOFF2.vcf raw.020.$CUTOFF.$CUTOFF2.vcf
	mv raw.21.$CUTOFF.$CUTOFF2.vcf raw.021.$CUTOFF.$CUTOFF2.vcf
	mv raw.22.$CUTOFF.$CUTOFF2.vcf raw.022.$CUTOFF.$CUTOFF2.vcf
	mv raw.23.$CUTOFF.$CUTOFF2.vcf raw.023.$CUTOFF.$CUTOFF2.vcf
	mv raw.24.$CUTOFF.$CUTOFF2.vcf raw.024.$CUTOFF.$CUTOFF2.vcf
	mv raw.25.$CUTOFF.$CUTOFF2.vcf raw.025.$CUTOFF.$CUTOFF2.vcf
	mv raw.26.$CUTOFF.$CUTOFF2.vcf raw.026.$CUTOFF.$CUTOFF2.vcf
	mv raw.27.$CUTOFF.$CUTOFF2.vcf raw.027.$CUTOFF.$CUTOFF2.vcf
	mv raw.28.$CUTOFF.$CUTOFF2.vcf raw.028.$CUTOFF.$CUTOFF2.vcf
	mv raw.29.$CUTOFF.$CUTOFF2.vcf raw.029.$CUTOFF.$CUTOFF2.vcf
	mv raw.30.$CUTOFF.$CUTOFF2.vcf raw.030.$CUTOFF.$CUTOFF2.vcf
	mv raw.31.$CUTOFF.$CUTOFF2.vcf raw.031.$CUTOFF.$CUTOFF2.vcf
	mv raw.32.$CUTOFF.$CUTOFF2.vcf raw.032.$CUTOFF.$CUTOFF2.vcf
	mv raw.33.$CUTOFF.$CUTOFF2.vcf raw.033.$CUTOFF.$CUTOFF2.vcf
	mv raw.34.$CUTOFF.$CUTOFF2.vcf raw.034.$CUTOFF.$CUTOFF2.vcf
	mv raw.35.$CUTOFF.$CUTOFF2.vcf raw.035.$CUTOFF.$CUTOFF2.vcf
	mv raw.36.$CUTOFF.$CUTOFF2.vcf raw.036.$CUTOFF.$CUTOFF2.vcf
	mv raw.37.$CUTOFF.$CUTOFF2.vcf raw.037.$CUTOFF.$CUTOFF2.vcf
	mv raw.38.$CUTOFF.$CUTOFF2.vcf raw.038.$CUTOFF.$CUTOFF2.vcf
	mv raw.39.$CUTOFF.$CUTOFF2.vcf raw.039.$CUTOFF.$CUTOFF2.vcf
	mv raw.40.$CUTOFF.$CUTOFF2.vcf raw.040.$CUTOFF.$CUTOFF2.vcf
	mv raw.41.$CUTOFF.$CUTOFF2.vcf raw.041.$CUTOFF.$CUTOFF2.vcf
	mv raw.42.$CUTOFF.$CUTOFF2.vcf raw.042.$CUTOFF.$CUTOFF2.vcf
	mv raw.43.$CUTOFF.$CUTOFF2.vcf raw.043.$CUTOFF.$CUTOFF2.vcf
	mv raw.44.$CUTOFF.$CUTOFF2.vcf raw.044.$CUTOFF.$CUTOFF2.vcf
	mv raw.45.$CUTOFF.$CUTOFF2.vcf raw.045.$CUTOFF.$CUTOFF2.vcf
	mv raw.46.$CUTOFF.$CUTOFF2.vcf raw.046.$CUTOFF.$CUTOFF2.vcf
	mv raw.47.$CUTOFF.$CUTOFF2.vcf raw.047.$CUTOFF.$CUTOFF2.vcf
	mv raw.48.$CUTOFF.$CUTOFF2.vcf raw.048.$CUTOFF.$CUTOFF2.vcf
	mv raw.49.$CUTOFF.$CUTOFF2.vcf raw.049.$CUTOFF.$CUTOFF2.vcf
	mv raw.50.$CUTOFF.$CUTOFF2.vcf raw.050.$CUTOFF.$CUTOFF2.vcf
	mv raw.51.$CUTOFF.$CUTOFF2.vcf raw.051.$CUTOFF.$CUTOFF2.vcf
	mv raw.52.$CUTOFF.$CUTOFF2.vcf raw.052.$CUTOFF.$CUTOFF2.vcf
	mv raw.53.$CUTOFF.$CUTOFF2.vcf raw.053.$CUTOFF.$CUTOFF2.vcf
	mv raw.54.$CUTOFF.$CUTOFF2.vcf raw.054.$CUTOFF.$CUTOFF2.vcf
	mv raw.55.$CUTOFF.$CUTOFF2.vcf raw.055.$CUTOFF.$CUTOFF2.vcf
	mv raw.56.$CUTOFF.$CUTOFF2.vcf raw.056.$CUTOFF.$CUTOFF2.vcf
	mv raw.57.$CUTOFF.$CUTOFF2.vcf raw.057.$CUTOFF.$CUTOFF2.vcf
	mv raw.58.$CUTOFF.$CUTOFF2.vcf raw.058.$CUTOFF.$CUTOFF2.vcf
	mv raw.59.$CUTOFF.$CUTOFF2.vcf raw.059.$CUTOFF.$CUTOFF2.vcf
	mv raw.60.$CUTOFF.$CUTOFF2.vcf raw.060.$CUTOFF.$CUTOFF2.vcf
	mv raw.61.$CUTOFF.$CUTOFF2.vcf raw.061.$CUTOFF.$CUTOFF2.vcf
	mv raw.62.$CUTOFF.$CUTOFF2.vcf raw.062.$CUTOFF.$CUTOFF2.vcf
	mv raw.63.$CUTOFF.$CUTOFF2.vcf raw.063.$CUTOFF.$CUTOFF2.vcf
	mv raw.64.$CUTOFF.$CUTOFF2.vcf raw.064.$CUTOFF.$CUTOFF2.vcf
	mv raw.65.$CUTOFF.$CUTOFF2.vcf raw.065.$CUTOFF.$CUTOFF2.vcf
	mv raw.66.$CUTOFF.$CUTOFF2.vcf raw.066.$CUTOFF.$CUTOFF2.vcf
	mv raw.67.$CUTOFF.$CUTOFF2.vcf raw.067.$CUTOFF.$CUTOFF2.vcf
	mv raw.68.$CUTOFF.$CUTOFF2.vcf raw.068.$CUTOFF.$CUTOFF2.vcf
	mv raw.69.$CUTOFF.$CUTOFF2.vcf raw.069.$CUTOFF.$CUTOFF2.vcf
	mv raw.70.$CUTOFF.$CUTOFF2.vcf raw.070.$CUTOFF.$CUTOFF2.vcf
	mv raw.71.$CUTOFF.$CUTOFF2.vcf raw.071.$CUTOFF.$CUTOFF2.vcf
	mv raw.72.$CUTOFF.$CUTOFF2.vcf raw.072.$CUTOFF.$CUTOFF2.vcf
	mv raw.73.$CUTOFF.$CUTOFF2.vcf raw.073.$CUTOFF.$CUTOFF2.vcf
	mv raw.74.$CUTOFF.$CUTOFF2.vcf raw.074.$CUTOFF.$CUTOFF2.vcf
	mv raw.75.$CUTOFF.$CUTOFF2.vcf raw.075.$CUTOFF.$CUTOFF2.vcf
	mv raw.76.$CUTOFF.$CUTOFF2.vcf raw.076.$CUTOFF.$CUTOFF2.vcf
	mv raw.77.$CUTOFF.$CUTOFF2.vcf raw.077.$CUTOFF.$CUTOFF2.vcf
	mv raw.78.$CUTOFF.$CUTOFF2.vcf raw.078.$CUTOFF.$CUTOFF2.vcf
	mv raw.79.$CUTOFF.$CUTOFF2.vcf raw.079.$CUTOFF.$CUTOFF2.vcf
	mv raw.80.$CUTOFF.$CUTOFF2.vcf raw.080.$CUTOFF.$CUTOFF2.vcf
	mv raw.81.$CUTOFF.$CUTOFF2.vcf raw.081.$CUTOFF.$CUTOFF2.vcf
	mv raw.82.$CUTOFF.$CUTOFF2.vcf raw.082.$CUTOFF.$CUTOFF2.vcf
	mv raw.83.$CUTOFF.$CUTOFF2.vcf raw.083.$CUTOFF.$CUTOFF2.vcf
	mv raw.84.$CUTOFF.$CUTOFF2.vcf raw.084.$CUTOFF.$CUTOFF2.vcf
	mv raw.85.$CUTOFF.$CUTOFF2.vcf raw.085.$CUTOFF.$CUTOFF2.vcf
	mv raw.86.$CUTOFF.$CUTOFF2.vcf raw.086.$CUTOFF.$CUTOFF2.vcf
	mv raw.87.$CUTOFF.$CUTOFF2.vcf raw.087.$CUTOFF.$CUTOFF2.vcf
	mv raw.88.$CUTOFF.$CUTOFF2.vcf raw.088.$CUTOFF.$CUTOFF2.vcf
	mv raw.89.$CUTOFF.$CUTOFF2.vcf raw.089.$CUTOFF.$CUTOFF2.vcf
	mv raw.90.$CUTOFF.$CUTOFF2.vcf raw.090.$CUTOFF.$CUTOFF2.vcf
	mv raw.91.$CUTOFF.$CUTOFF2.vcf raw.091.$CUTOFF.$CUTOFF2.vcf
	mv raw.92.$CUTOFF.$CUTOFF2.vcf raw.092.$CUTOFF.$CUTOFF2.vcf
	mv raw.93.$CUTOFF.$CUTOFF2.vcf raw.093.$CUTOFF.$CUTOFF2.vcf
	mv raw.94.$CUTOFF.$CUTOFF2.vcf raw.094.$CUTOFF.$CUTOFF2.vcf
	mv raw.95.$CUTOFF.$CUTOFF2.vcf raw.095.$CUTOFF.$CUTOFF2.vcf
	mv raw.96.$CUTOFF.$CUTOFF2.vcf raw.096.$CUTOFF.$CUTOFF2.vcf
	mv raw.97.$CUTOFF.$CUTOFF2.vcf raw.097.$CUTOFF.$CUTOFF2.vcf
	mv raw.98.$CUTOFF.$CUTOFF2.vcf raw.098.$CUTOFF.$CUTOFF2.vcf
	mv raw.99.$CUTOFF.$CUTOFF2.vcf raw.099.$CUTOFF.$CUTOFF2.vcf
	
	module load vcflib/1.0
	module load vcftools/0.1.15
	
	vcfcombine raw.*.$CUTOFF.$CUTOFF2.vcf | sed -e 's/	\.\:/	\.\/\.\:/g' > TotalRawSNPs.$CUTOFF.$CUTOFF2.vcf

	if [ ! -d "raw.$CUTOFF.$CUTOFF2.vcf" ]; then
		mkdir raw.$CUTOFF.$CUTOFF2.vcf
	fi

	mv raw.*.$CUTOFF.$CUTOFF2.vcf ./raw.$CUTOFF.$CUTOFF2.vcf
	

	echo "";echo `date` " Using VCFtools to parse SNPS.vcf for SNPs that are called in at least 90% of individuals"
	vcftools --vcf TotalRawSNPs.$CUTOFF.$CUTOFF2.vcf --max-missing 0.9 --out Final90 --recode --non-ref-af 0.001 --max-non-ref-af 0.9999 --mac 1 --minQ 30 --recode-INFO-all &>VCFtools.$CUTOFF.$CUTOFF2.log
	vcftools --vcf TotalRawSNPs.$CUTOFF.$CUTOFF2.vcf --max-missing 1 --out Final100 --recode --non-ref-af 0.001 --max-non-ref-af 0.9999 --mac 1 --minQ 30 --recode-INFO-all &>>VCFtools.$CUTOFF.$CUTOFF2.log
	
	echo "";echo `date` " Renaming vcf output"
	mv Final.recode.vcf Final.recode.$CUTOFF.$CUTOFF2.vcf
	mv Final.frq.count Final.frq.$CUTOFF.$CUTOFF2.count

	
	else
		#Call SNP nha
			DP=$(mawk '{print $4}' cov.$CUTOFF.$CUTOFF2.stats | sort -rn | perl -e '$d=.001;@l=<>;print $l[int($d*@l)]')
	CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/200}')

	echo `date` " Making the bed files"
	mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats |sort -V -k1,1 -k2,2 | mawk -v x1="$CUTOFF.$CUTOFF2" -v cutoff=$CC 'BEGIN{i=1} 
	{
		len=$3-$2;lc=len*$4;cov = cov + lc
		if ( cov < cutoff) {x="mapped."i"."x1".bed";print $1"\t"$2"\t"$3 > x}
		else {i=i+1; x="mapped."i"."x1".bed"; print $1"\t"$2"\t"$3 > x; cov=0}
	}' 
	#Creates a population file to use for more accurate genotype calling
	cut -f1 -d "_" namelist > p.$CUTOFF.$CUTOFF2
	paste namelist p.$CUTOFF.$CUTOFF2 > popmap.$CUTOFF.$CUTOFF2
	rm p.$CUTOFF.$CUTOFF2
	
	echo "Call SNPs with 10 cpu threads"	
	mv mapped.$CUTOFF.$CUTOFF2.bed mapped.$CUTOFF.$CUTOFF2
	ls mapped.*.bed | sed 's/mapped.//g' | sed 's/.bed//g' | shuf | parallel -j 10 --no-notice --delay 1 freebayes -L bamlist.$CUTOFF.$CUTOFF2.list -t mapped.{}.bed -v raw.{}.vcf -f reference.$CUTOFF.$CUTOFF2.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap.$CUTOFF.$CUTOFF2 -n 10
	
	echo "Processing vcf file and make Raw SNPs"	
	rm mapped.*.$CUTOFF.$CUTOFF2.bed 

	mv raw.1.$CUTOFF.$CUTOFF2.vcf raw.001.$CUTOFF.$CUTOFF2.vcf
	mv raw.2.$CUTOFF.$CUTOFF2.vcf raw.002.$CUTOFF.$CUTOFF2.vcf
	mv raw.3.$CUTOFF.$CUTOFF2.vcf raw.003.$CUTOFF.$CUTOFF2.vcf
	mv raw.4.$CUTOFF.$CUTOFF2.vcf raw.004.$CUTOFF.$CUTOFF2.vcf
	mv raw.5.$CUTOFF.$CUTOFF2.vcf raw.005.$CUTOFF.$CUTOFF2.vcf
	mv raw.6.$CUTOFF.$CUTOFF2.vcf raw.006.$CUTOFF.$CUTOFF2.vcf
	mv raw.7.$CUTOFF.$CUTOFF2.vcf raw.007.$CUTOFF.$CUTOFF2.vcf
	mv raw.8.$CUTOFF.$CUTOFF2.vcf raw.008.$CUTOFF.$CUTOFF2.vcf
	mv raw.9.$CUTOFF.$CUTOFF2.vcf raw.009.$CUTOFF.$CUTOFF2.vcf
	mv raw.10.$CUTOFF.$CUTOFF2.vcf raw.010.$CUTOFF.$CUTOFF2.vcf
	mv raw.11.$CUTOFF.$CUTOFF2.vcf raw.011.$CUTOFF.$CUTOFF2.vcf
	mv raw.12.$CUTOFF.$CUTOFF2.vcf raw.012.$CUTOFF.$CUTOFF2.vcf
	mv raw.13.$CUTOFF.$CUTOFF2.vcf raw.013.$CUTOFF.$CUTOFF2.vcf
	mv raw.14.$CUTOFF.$CUTOFF2.vcf raw.014.$CUTOFF.$CUTOFF2.vcf
	mv raw.15.$CUTOFF.$CUTOFF2.vcf raw.015.$CUTOFF.$CUTOFF2.vcf
	mv raw.16.$CUTOFF.$CUTOFF2.vcf raw.016.$CUTOFF.$CUTOFF2.vcf
	mv raw.17.$CUTOFF.$CUTOFF2.vcf raw.017.$CUTOFF.$CUTOFF2.vcf
	mv raw.18.$CUTOFF.$CUTOFF2.vcf raw.018.$CUTOFF.$CUTOFF2.vcf
	mv raw.19.$CUTOFF.$CUTOFF2.vcf raw.019.$CUTOFF.$CUTOFF2.vcf
	mv raw.20.$CUTOFF.$CUTOFF2.vcf raw.020.$CUTOFF.$CUTOFF2.vcf
	mv raw.21.$CUTOFF.$CUTOFF2.vcf raw.021.$CUTOFF.$CUTOFF2.vcf
	mv raw.22.$CUTOFF.$CUTOFF2.vcf raw.022.$CUTOFF.$CUTOFF2.vcf
	mv raw.23.$CUTOFF.$CUTOFF2.vcf raw.023.$CUTOFF.$CUTOFF2.vcf
	mv raw.24.$CUTOFF.$CUTOFF2.vcf raw.024.$CUTOFF.$CUTOFF2.vcf
	mv raw.25.$CUTOFF.$CUTOFF2.vcf raw.025.$CUTOFF.$CUTOFF2.vcf
	mv raw.26.$CUTOFF.$CUTOFF2.vcf raw.026.$CUTOFF.$CUTOFF2.vcf
	mv raw.27.$CUTOFF.$CUTOFF2.vcf raw.027.$CUTOFF.$CUTOFF2.vcf
	mv raw.28.$CUTOFF.$CUTOFF2.vcf raw.028.$CUTOFF.$CUTOFF2.vcf
	mv raw.29.$CUTOFF.$CUTOFF2.vcf raw.029.$CUTOFF.$CUTOFF2.vcf
	mv raw.30.$CUTOFF.$CUTOFF2.vcf raw.030.$CUTOFF.$CUTOFF2.vcf
	mv raw.31.$CUTOFF.$CUTOFF2.vcf raw.031.$CUTOFF.$CUTOFF2.vcf
	mv raw.32.$CUTOFF.$CUTOFF2.vcf raw.032.$CUTOFF.$CUTOFF2.vcf
	mv raw.33.$CUTOFF.$CUTOFF2.vcf raw.033.$CUTOFF.$CUTOFF2.vcf
	mv raw.34.$CUTOFF.$CUTOFF2.vcf raw.034.$CUTOFF.$CUTOFF2.vcf
	mv raw.35.$CUTOFF.$CUTOFF2.vcf raw.035.$CUTOFF.$CUTOFF2.vcf
	mv raw.36.$CUTOFF.$CUTOFF2.vcf raw.036.$CUTOFF.$CUTOFF2.vcf
	mv raw.37.$CUTOFF.$CUTOFF2.vcf raw.037.$CUTOFF.$CUTOFF2.vcf
	mv raw.38.$CUTOFF.$CUTOFF2.vcf raw.038.$CUTOFF.$CUTOFF2.vcf
	mv raw.39.$CUTOFF.$CUTOFF2.vcf raw.039.$CUTOFF.$CUTOFF2.vcf
	mv raw.40.$CUTOFF.$CUTOFF2.vcf raw.040.$CUTOFF.$CUTOFF2.vcf
	mv raw.41.$CUTOFF.$CUTOFF2.vcf raw.041.$CUTOFF.$CUTOFF2.vcf
	mv raw.42.$CUTOFF.$CUTOFF2.vcf raw.042.$CUTOFF.$CUTOFF2.vcf
	mv raw.43.$CUTOFF.$CUTOFF2.vcf raw.043.$CUTOFF.$CUTOFF2.vcf
	mv raw.44.$CUTOFF.$CUTOFF2.vcf raw.044.$CUTOFF.$CUTOFF2.vcf
	mv raw.45.$CUTOFF.$CUTOFF2.vcf raw.045.$CUTOFF.$CUTOFF2.vcf
	mv raw.46.$CUTOFF.$CUTOFF2.vcf raw.046.$CUTOFF.$CUTOFF2.vcf
	mv raw.47.$CUTOFF.$CUTOFF2.vcf raw.047.$CUTOFF.$CUTOFF2.vcf
	mv raw.48.$CUTOFF.$CUTOFF2.vcf raw.048.$CUTOFF.$CUTOFF2.vcf
	mv raw.49.$CUTOFF.$CUTOFF2.vcf raw.049.$CUTOFF.$CUTOFF2.vcf
	mv raw.50.$CUTOFF.$CUTOFF2.vcf raw.050.$CUTOFF.$CUTOFF2.vcf
	mv raw.51.$CUTOFF.$CUTOFF2.vcf raw.051.$CUTOFF.$CUTOFF2.vcf
	mv raw.52.$CUTOFF.$CUTOFF2.vcf raw.052.$CUTOFF.$CUTOFF2.vcf
	mv raw.53.$CUTOFF.$CUTOFF2.vcf raw.053.$CUTOFF.$CUTOFF2.vcf
	mv raw.54.$CUTOFF.$CUTOFF2.vcf raw.054.$CUTOFF.$CUTOFF2.vcf
	mv raw.55.$CUTOFF.$CUTOFF2.vcf raw.055.$CUTOFF.$CUTOFF2.vcf
	mv raw.56.$CUTOFF.$CUTOFF2.vcf raw.056.$CUTOFF.$CUTOFF2.vcf
	mv raw.57.$CUTOFF.$CUTOFF2.vcf raw.057.$CUTOFF.$CUTOFF2.vcf
	mv raw.58.$CUTOFF.$CUTOFF2.vcf raw.058.$CUTOFF.$CUTOFF2.vcf
	mv raw.59.$CUTOFF.$CUTOFF2.vcf raw.059.$CUTOFF.$CUTOFF2.vcf
	mv raw.60.$CUTOFF.$CUTOFF2.vcf raw.060.$CUTOFF.$CUTOFF2.vcf
	mv raw.61.$CUTOFF.$CUTOFF2.vcf raw.061.$CUTOFF.$CUTOFF2.vcf
	mv raw.62.$CUTOFF.$CUTOFF2.vcf raw.062.$CUTOFF.$CUTOFF2.vcf
	mv raw.63.$CUTOFF.$CUTOFF2.vcf raw.063.$CUTOFF.$CUTOFF2.vcf
	mv raw.64.$CUTOFF.$CUTOFF2.vcf raw.064.$CUTOFF.$CUTOFF2.vcf
	mv raw.65.$CUTOFF.$CUTOFF2.vcf raw.065.$CUTOFF.$CUTOFF2.vcf
	mv raw.66.$CUTOFF.$CUTOFF2.vcf raw.066.$CUTOFF.$CUTOFF2.vcf
	mv raw.67.$CUTOFF.$CUTOFF2.vcf raw.067.$CUTOFF.$CUTOFF2.vcf
	mv raw.68.$CUTOFF.$CUTOFF2.vcf raw.068.$CUTOFF.$CUTOFF2.vcf
	mv raw.69.$CUTOFF.$CUTOFF2.vcf raw.069.$CUTOFF.$CUTOFF2.vcf
	mv raw.70.$CUTOFF.$CUTOFF2.vcf raw.070.$CUTOFF.$CUTOFF2.vcf
	mv raw.71.$CUTOFF.$CUTOFF2.vcf raw.071.$CUTOFF.$CUTOFF2.vcf
	mv raw.72.$CUTOFF.$CUTOFF2.vcf raw.072.$CUTOFF.$CUTOFF2.vcf
	mv raw.73.$CUTOFF.$CUTOFF2.vcf raw.073.$CUTOFF.$CUTOFF2.vcf
	mv raw.74.$CUTOFF.$CUTOFF2.vcf raw.074.$CUTOFF.$CUTOFF2.vcf
	mv raw.75.$CUTOFF.$CUTOFF2.vcf raw.075.$CUTOFF.$CUTOFF2.vcf
	mv raw.76.$CUTOFF.$CUTOFF2.vcf raw.076.$CUTOFF.$CUTOFF2.vcf
	mv raw.77.$CUTOFF.$CUTOFF2.vcf raw.077.$CUTOFF.$CUTOFF2.vcf
	mv raw.78.$CUTOFF.$CUTOFF2.vcf raw.078.$CUTOFF.$CUTOFF2.vcf
	mv raw.79.$CUTOFF.$CUTOFF2.vcf raw.079.$CUTOFF.$CUTOFF2.vcf
	mv raw.80.$CUTOFF.$CUTOFF2.vcf raw.080.$CUTOFF.$CUTOFF2.vcf
	mv raw.81.$CUTOFF.$CUTOFF2.vcf raw.081.$CUTOFF.$CUTOFF2.vcf
	mv raw.82.$CUTOFF.$CUTOFF2.vcf raw.082.$CUTOFF.$CUTOFF2.vcf
	mv raw.83.$CUTOFF.$CUTOFF2.vcf raw.083.$CUTOFF.$CUTOFF2.vcf
	mv raw.84.$CUTOFF.$CUTOFF2.vcf raw.084.$CUTOFF.$CUTOFF2.vcf
	mv raw.85.$CUTOFF.$CUTOFF2.vcf raw.085.$CUTOFF.$CUTOFF2.vcf
	mv raw.86.$CUTOFF.$CUTOFF2.vcf raw.086.$CUTOFF.$CUTOFF2.vcf
	mv raw.87.$CUTOFF.$CUTOFF2.vcf raw.087.$CUTOFF.$CUTOFF2.vcf
	mv raw.88.$CUTOFF.$CUTOFF2.vcf raw.088.$CUTOFF.$CUTOFF2.vcf
	mv raw.89.$CUTOFF.$CUTOFF2.vcf raw.089.$CUTOFF.$CUTOFF2.vcf
	mv raw.90.$CUTOFF.$CUTOFF2.vcf raw.090.$CUTOFF.$CUTOFF2.vcf
	mv raw.91.$CUTOFF.$CUTOFF2.vcf raw.091.$CUTOFF.$CUTOFF2.vcf
	mv raw.92.$CUTOFF.$CUTOFF2.vcf raw.092.$CUTOFF.$CUTOFF2.vcf
	mv raw.93.$CUTOFF.$CUTOFF2.vcf raw.093.$CUTOFF.$CUTOFF2.vcf
	mv raw.94.$CUTOFF.$CUTOFF2.vcf raw.094.$CUTOFF.$CUTOFF2.vcf
	mv raw.95.$CUTOFF.$CUTOFF2.vcf raw.095.$CUTOFF.$CUTOFF2.vcf
	mv raw.96.$CUTOFF.$CUTOFF2.vcf raw.096.$CUTOFF.$CUTOFF2.vcf
	mv raw.97.$CUTOFF.$CUTOFF2.vcf raw.097.$CUTOFF.$CUTOFF2.vcf
	mv raw.98.$CUTOFF.$CUTOFF2.vcf raw.098.$CUTOFF.$CUTOFF2.vcf
	mv raw.99.$CUTOFF.$CUTOFF2.vcf raw.099.$CUTOFF.$CUTOFF2.vcf
	
	module load vcflib/1.0
	module load vcftools/0.1.15
	
	vcfcombine raw.*.$CUTOFF.$CUTOFF2.vcf | sed -e 's/	\.\:/	\.\/\.\:/g' > TotalRawSNPs.$CUTOFF.$CUTOFF2.vcf

	if [ ! -d "raw.$CUTOFF.$CUTOFF2.vcf" ]; then
		mkdir raw.$CUTOFF.$CUTOFF2.vcf
	fi

	mv raw.*.$CUTOFF.$CUTOFF2.vcf ./raw.$CUTOFF.$CUTOFF2.vcf

	echo "";echo `date` " Using VCFtools to parse SNPS.vcf for SNPs that are called in at least 90% of individuals"
	vcftools --vcf TotalRawSNPs.$CUTOFF.$CUTOFF2.vcf --max-missing 0.9 --out Final90 --recode --non-ref-af 0.001 --max-non-ref-af 0.9999 --mac 1 --minQ 30 --recode-INFO-all &>VCFtools.$CUTOFF.$CUTOFF2.log
	vcftools --vcf TotalRawSNPs.$CUTOFF.$CUTOFF2.vcf --max-missing 1 --out Final100 --recode --non-ref-af 0.001 --max-non-ref-af 0.9999 --mac 1 --minQ 30 --recode-INFO-all &>>VCFtools.$CUTOFF.$CUTOFF2.log
	
	echo "";echo `date` " Renaming vcf output"
	mv Final.recode.vcf Final.recode.$CUTOFF.$CUTOFF2.vcf
	mv Final.frq.count Final.frq.$CUTOFF.$CUTOFF2.count

fi

#Ket thuc phan tao SNP tho nha!
