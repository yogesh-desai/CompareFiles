#!/bin/bash
# This code compare file sizes within the given date range. 
# This code creates 3 output txt files as follows,
# 1. Matched Files
# 2. Mismatched Files,
# 3. MissingFiles.
# Please check src & dest path before you run the code.

StartDate=`date +"%Y%m%d" -d $1`  #"20160121
EndDate=`date +"%Y%m%d" -d $2`    #"20160123"

src=/home/yogesh/bash-tp
dest=/home/yogesh/bash-tp/desti

if [ $# -ne 2 ]
then
    echo "Usage:`basename $0` Start_Date End_Date"
    echo "e.g. :bash CompareFiles.bash 20160621 20160625"
    exit $E_BADARGS
fi

if [[ ! -d $src || ! -d $dest ]]
then
    echo "Given source or destination path doesn't exist."
    exit $E_NOFILE
fi

echo "Now: "$StartDate
echo "End: "$EndDate
echo "src: "$src
echo "dest: "$dest

# Delete Files if already exists.
 for i in OutM*; do if [[  -f "$i" ]]; then rm -f $i; fi; done

function CompareFiles {

srcpath=$src/$StartDate/*

for srcfile in $srcpath
do

    destfile=${srcfile/$src/$dest} 

    echo "Srcfilepath: "$srcfile
    echo "Destfilepath: "$destfile

     if [ -f $destfile ]
     then

    filesize=`ls -l  $srcfile | awk '{print $5}'`
    destfilesize=`ls -l  $destfile | awk '{print $2}'`

    echo "SrcFilesize: "$filesize
    echo "DestFilesize: "$destfilesize
        if [ "$filesize" == "$destfilesize" ]
        then
        # File names which matches in size will be written into following file.
            echo $destfile >>OutMatchFiles.txt
        else
        # File names which do not matches in size will be written into following file.
            echo $destfile >>OutMismatchFiles.txt
        fi
     else
     # File names which do not exists in destination path will be written into following file.
        echo $destfile >>OutMissingFiles.txt
     fi
done #For Complete                                                                                                                                                                                                                      
    }

while [ "$StartDate" -le "$EndDate" ] ;
do
 
    echo "Date being Processed: "$StartDate

    CompareFiles

    StartDate=`date +"%Y%m%d" -d "$StartDate + 1 day"`;

done
echo "All Done"
