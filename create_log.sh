#!/bin/bash

# LOG CREATION
# STICKEL
# WITH A TWIST STUDIO
# 08.12.10

title="Your Studio Name"

NUMDAYOFWEEK=`date +%u`
#echo "NUMDAYOFWEEK:" $NUMDAYOFWEEK

# DECLARES DAYS OF THE WEEK ARRAY
Days=(Mon Tue Wed Thu Fri Sat Sun)

# DECALRES WHAT DAY OF THE WEEK TODAY WOULD BE
# DEFAULT OFFSET = -1
TODAY=${Days[$NUMDAYOFWEEK-1]}
#echo "TODAY:" $TODAY

# DECALRES DATE USING TWO DIGITAL REPRESENTATION (e.g 10.14.09)
DATE=`date +%m.%d.%y`
#echo "DATE:" $DATE

log_file=WAT_Log_$DATE.log
#echo $log_file

echo $title > $log_file
echo "TODAY:" $TODAY >> $log_file
echo "DATE:" $DATE >> $log_file

echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file

echo "----- FOLDER FILE SIZE -----" >> $log_file
echo >> $log_file
du -h * >> $log_file

echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file

echo "----- LIST OF DIRECTORIES -----" >> $log_file
echo >> $log_file
find ./ -type d >> $log_file

echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file
echo >> $log_file

echo "----- LIST OF FILES -----" >> $log_file
echo >> $log_file
ls -lAhRTn >> $log_file