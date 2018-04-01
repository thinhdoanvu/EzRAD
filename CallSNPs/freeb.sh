#!/bin/bash

#SBATCH --job-name=freeb65
#SBATCH --time=96:00:00
#SBATCH -p normal
#SBATCH --nodes=1
#SBATCH --mail-user=thinhdv@ntu.edu.vn
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finish

module load ddocent/2.24
echo "chi su dug cai nay trong truong hop ma thuc hien call SNP bi bao loi do cai phan cai tien cua Cbird"

CUTOFF=XXX
CUTOFF2=YYY

echo "kiem tra file: mapped.$CUTOFF.$CUTOFF2.bed"
#Neu nhu chua co file mapped*bed thi tien hanh tao ra em no

if [ ! -f "mapped.$CUTOFF.$CUTOFF2.bed" ]; then
	echo "CreateIntervals"
	echo ""; echo `date` " recreating intervals again"
	bamToBed -i cat.$CUTOFF.$CUTOFF2-RRG.bam > map.$CUTOFF.$CUTOFF2.bed
	bedtools merge -i map.$CUTOFF.$CUTOFF2.bed > mapped.$CUTOFF.$CUTOFF2.bed
	
	#rm map.$CUTOFF.$CUTOFF2.bed 
	
	#This code estimates the coverage of reference intervals and removes intervals in 0.01% of depth
	#This allows genotyping to be more effecient and eliminates extreme copy number loci from the data
	echo "";echo `date` " Estimate coverage of ref intervals & remove extreme copy number loci"
	if [ "cat.$CUTOFF.$CUTOFF2-RRG.bam" -nt "cov.$CUTOFF.$CUTOFF2.stats" ]; then
		coverageBed -abam cat.$CUTOFF.$CUTOFF2-RRG.bam -b mapped.$CUTOFF.$CUTOFF2.bed -counts > cov.$CUTOFF.$CUTOFF2.stats
	fi
	
	if head -1 reference.$CUTOFF.$CUTOFF2.fasta | grep -e 'dDocent' reference.$CUTOFF.$CUTOFF2.fasta 1>/dev/null; then
		
		DP=$(mawk '{print $4}' cov.$CUTOFF.$CUTOFF2.stats | sort -rn | perl -e '$d=.001;@l=<>;print $l[int($d*@l)]')
		#CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/"'$NUMProc'"}')
		CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/20}')
	else
		DP=$(mawk '{print $4}' cov.$CUTOFF.$CUTOFF2.stats | sort -rn | perl -e '$d=.00005;@l=<>;print $l[int($d*@l)]')
		#CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/"'$NUMProc'"}')
		CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/20}')
	fi
	
	echo ""
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

	#Goi chuong trinh tao SNPs calling
	echo "SNPCalling"
	echo "Call SNPs with 10 cpu threads"	
	
	
	ls mapped.*.bed | sed 's/mapped.//g' | sed 's/.bed//g' | shuf | parallel -j 10 --no-notice --delay 1 freebayes -L bamlist.$CUTOFF.$CUTOFF2.list -t mapped.{}.bed -v raw.{}.vcf -f reference.$CUTOFF.$CUTOFF2.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap.$CUTOFF.$CUTOFF2 -n 10
	
	echo "Processing vcf file and make Raw SNPs"	
	#rm mapped.*.$CUTOFF.$CUTOFF2.bed 

	mv raw.1.$CUTOFF.$CUTOFF2.vcf raw.01.$CUTOFF.$CUTOFF2.vcf
	mv raw.2.$CUTOFF.$CUTOFF2.vcf raw.02.$CUTOFF.$CUTOFF2.vcf
	mv raw.3.$CUTOFF.$CUTOFF2.vcf raw.03.$CUTOFF.$CUTOFF2.vcf
	mv raw.4.$CUTOFF.$CUTOFF2.vcf raw.04.$CUTOFF.$CUTOFF2.vcf
	mv raw.5.$CUTOFF.$CUTOFF2.vcf raw.05.$CUTOFF.$CUTOFF2.vcf
	mv raw.6.$CUTOFF.$CUTOFF2.vcf raw.06.$CUTOFF.$CUTOFF2.vcf
	mv raw.7.$CUTOFF.$CUTOFF2.vcf raw.07.$CUTOFF.$CUTOFF2.vcf
	mv raw.8.$CUTOFF.$CUTOFF2.vcf raw.08.$CUTOFF.$CUTOFF2.vcf
	mv raw.9.$CUTOFF.$CUTOFF2.vcf raw.09.$CUTOFF.$CUTOFF2.vcf

	echo "loading module vcflib to combine vcf file"	
	module load vcflib/1.0

	echo "loading vcftools/0.1.5 for max-missing filtering"
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

##NGUOC LAI NE
	else
	echo "da co bed file, gio tao lai cov.stast"
	
	echo "";echo `date` " Estimate coverage of ref intervals & remove extreme copy number loci"
	if [ "cat.$CUTOFF.$CUTOFF2-RRG.bam" -nt "cov.$CUTOFF.$CUTOFF2.stats" ]; then
		coverageBed -abam cat.$CUTOFF.$CUTOFF2-RRG.bam -b mapped.$CUTOFF.$CUTOFF2.bed -counts > cov.$CUTOFF.$CUTOFF2.stats
	fi
	
	if head -1 reference.$CUTOFF.$CUTOFF2.fasta | grep -e 'dDocent' reference.$CUTOFF.$CUTOFF2.fasta 1>/dev/null; then
		
		DP=$(mawk '{print $4}' cov.$CUTOFF.$CUTOFF2.stats | sort -rn | perl -e '$d=.001;@l=<>;print $l[int($d*@l)]')
		#CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/"'$NUMProc'"}')
		CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/20}')
	else
		DP=$(mawk '{print $4}' cov.$CUTOFF.$CUTOFF2.stats | sort -rn | perl -e '$d=.00005;@l=<>;print $l[int($d*@l)]')
		#CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/"'$NUMProc'"}')
		CC=$( mawk -v x=$DP '$4 < x' cov.$CUTOFF.$CUTOFF2.stats | mawk '{len=$3-$2;lc=len*$4;tl=tl+lc} END {OFMT = "%.0f";print tl/20}')
	fi
	
	echo ""
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

	#Goi chuong trinh tao SNPs calling
	echo "SNPCalling"
	echo "Call SNPs with 10 cpu threads"	
	
	
	ls mapped.*.bed | sed 's/mapped.//g' | sed 's/.bed//g' | shuf | parallel -j 10 --no-notice --delay 1 freebayes -L bamlist.$CUTOFF.$CUTOFF2.list -t mapped.{}.bed -v raw.{}.vcf -f reference.$CUTOFF.$CUTOFF2.fasta -m 5 -q 5 -E 3 --min-repeat-entropy 1 -V --populations popmap.$CUTOFF.$CUTOFF2 -n 10
	
	echo "Processing vcf file and make Raw SNPs"	
	#rm mapped.*.$CUTOFF.$CUTOFF2.bed 

	mv raw.1.$CUTOFF.$CUTOFF2.vcf raw.01.$CUTOFF.$CUTOFF2.vcf
	mv raw.2.$CUTOFF.$CUTOFF2.vcf raw.02.$CUTOFF.$CUTOFF2.vcf
	mv raw.3.$CUTOFF.$CUTOFF2.vcf raw.03.$CUTOFF.$CUTOFF2.vcf
	mv raw.4.$CUTOFF.$CUTOFF2.vcf raw.04.$CUTOFF.$CUTOFF2.vcf
	mv raw.5.$CUTOFF.$CUTOFF2.vcf raw.05.$CUTOFF.$CUTOFF2.vcf
	mv raw.6.$CUTOFF.$CUTOFF2.vcf raw.06.$CUTOFF.$CUTOFF2.vcf
	mv raw.7.$CUTOFF.$CUTOFF2.vcf raw.07.$CUTOFF.$CUTOFF2.vcf
	mv raw.8.$CUTOFF.$CUTOFF2.vcf raw.08.$CUTOFF.$CUTOFF2.vcf
	mv raw.9.$CUTOFF.$CUTOFF2.vcf raw.09.$CUTOFF.$CUTOFF2.vcf

	echo "loading module vcflib to combine vcf file"	
	module load vcflib/1.0

	echo "loading vcftools/0.1.5 for max-missing filtering"
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
