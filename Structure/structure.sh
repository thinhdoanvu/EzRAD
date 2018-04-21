#! /bin/bash

#set the sbatch stuff
#SBATCH -J Structure
#SBATCH -o filename.error
#SBATCH -p normal
#SBATCH -t 24:00:00
#SBATCH --mail-user=thinhdv@ntu.edu.vn
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finish

#load modules
module load structure/2.3.4
module load parallel/20160722

#make files named K.txt and rep.txt with number from 1 to K and 1 to reps
# where k is the number of groups structure is fitting
# and reps are the number of times to replicate

seq 2 2 > K.txt
seq 1 1 > rep.txt
parallel -j 20 --delay 0.1 "structure -m mainparams -e extraparams -K {1} -o Out_K{1}_rep{2}" :::: K.txt rep.txt

grep BURNIN mainparams | sed 's/ /\t/g' | cut -f3 >dir1
grep NUMREPS mainparams | sed 's/ /\t/g' | cut -f3 >>dir2
paste dir1 dir2 | sed 's/\t//g' > dir
rm dir1
rm dir2
t=$(cat dir)

mkdir $t
mv Out* $t/

