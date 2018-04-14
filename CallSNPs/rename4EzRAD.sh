#!/bin/bash
checkfinish()
{
  echo "Do you want to finish job? (y/n)"
  read ansfin
  if [ "$ansfin" == "n" ]
  then
    ls
    begin
  else
      ls
	if [ -f 1 ]
	then
	  rm 1
	fi
	if [ -f 2 ]
	then
	  rm 2
	fi
    if [ -f 3 ]
	then
	  rm 3
	fi
    if [ -f 4 ]
	then
	  rm 4
	fi
	if [ -f sourcename ]
	then
	  rm sourcename
	fi
	if [ -f rename ]
	then
	  rm rename
	fi
	if [ -f dthinh.rename.sh ]
	then
	  rm dthinh.rename.sh
	fi
  fi
}

checkanswers()
{
echo "Do you want to start?(y/n)"
read bgin
if [ "$bgin" == "n" ]
then
  clear
  ls
else
  date
  echo "contact thinhdv@ntu.edu.vn"
	#Doing excercise now
  begin
fi
}

checkremains()
{
ls *R1_001.fastq.gz 2>err2
errnum=$(grep -c "cannot access" err2)
if [ $errnum -gt 0 ]
then
  echo "You don't have any files to rename"
  rm err2
  if [ -f 1 ]
	then
	  rm 1
	fi
	if [ -f 2 ]
	then
	  rm 2
	fi
    if [ -f 3 ]
	then
	  rm 3
	fi
    if [ -f 4 ]
	then
	  rm 4
	fi
	if [ -f sourcename ]
	then
	  rm sourcename
	fi
	if [ -f rename ]
	then
	  rm rename
	fi
	if [ -f dthinh.rename.sh ]
	then
	  rm dthinh.rename.sh
	fi
	if [ -f err ]
	then
	  rm err
	fi
  exit
else
  echo "Do you want to repeat again? (y/n)"
  read ans1
  if [ "$ans1" == "n" ]
  then
    exit
  else
    ls
    begin
  fi
fi
}


#Code 4 begin here

begin()
{
echo "These are list of suffix name need to be changed:"
ls *gz | sed 's/_R1_001.fastq.gz//g;s/_R2_001.fastq.gz//g' | cut -f1-3 -d"_" | sed 's/\t/_/g'
echo "please insert your suffix individual file name, ie: T_VN_VL means for Trichopodus_Vietnam_VinhLong"
read sname

#Checking file name exist yet?
ls $sname* 2>err
errnum=$(grep -c "cannot access" err)
if [ $errnum -gt 0 ]
then
  echo "Please checking your suffix name..."
  cat err
  rm err
  exit
else

#Check 2 files F and R
tF=$(ls $sname*R1*.fastq.gz | wc -l)
tR=$(ls $sname*R2*.fastq.gz | wc -l)
t=$tF

#Checking number of F file and R file
if [ $tF -eq $tR ]
then
  echo "You have "$t" individuals inside"
else
  echo "Please check your sequnce data, because the"$tF "Forward file is not equal with "$tR" Reverse file"
  exit
fi

#"$t" convert text to number

if [ "$t" -gt 0 ]
then
echo "You have "$t "sample files need to rename"
else
  echo "You don't have any files"
fi

#List of name file
ls $sname* | nl

#Making ordered numbering name files
if [ "$t" -lt 10 ]
then
  seq 1 $t | awk '{print "0"$0}' | awk '{print $0"\n"$0}' > 2
else
  seq 1 9 | awk '{print "0"$0}' >1
  seq 10 $t >>1
  awk '{print $0"\n"$0}' 1 >2
fi

#Making source name file
ls $sname* | awk '{print "mv "$0}' >sourcename
echo "your list file names here:"
echo "-----------------------------------------------------------"
cat sourcename
echo "-----------------------------------------------------------"

#Making new name file
echo "type your destination name file [Country_Location], ie: VN_VL"
read rname

#Open 2 file
opf=$(cat 2)

#Check file 3
if [ -f 3 ]
then
  rm 3
else
for i in $opf
do
  echo $rname$i >>3
done

fi

ls $sname* | sed 's/R1_001.fastq/.F.fq/g;s/R2_001.fastq/.R.fq/g' | sed 's/_/\t/g' | awk '{print $NF}'>4
cat 4

paste 3 4 | sed 's/\t//g'>rename

#List rename file
echo "New name here:"
echo "-------------------------------------------------"
cat rname
echo "-------------------------------------------------"

#Check again
paste sourcename rename >dthinh.rename.sh
cat dthinh.rename.sh

#Check again, please
clear
echo "This is your command:"
cat dthinh.rename.sh
echo "Do you want to rename all of them? (y/n)"
read ans1

#checking answer1
if [ "$ans1" == "y" ]
then
  bash dthinh.rename.sh
else
  exit
fi
#End of check name file exist
fi
}

#Code will be execute here
checkanswers
checkremains
checkfinish