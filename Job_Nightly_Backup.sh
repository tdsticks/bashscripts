#!/bin/bash

# PATHS ------------------------------------------------------------------------------------

# DIRECTORY OF SOURCE (TO BE BACKED UP)
SURCE=/mnt/speakeasy/jobs
SURCEJOB=$SURCE/

#echo $SURCE

# DIRECTORY OF DESTINATION
DEST=/mnt/pbr/jobs
#DEST=/media/WAT_ARCH/backups
DESTJOB=$DEST/

#echo $DEST
# ------------------------------------------------------------------------------------------

# LOG DIRECTORY AND FILENAME
#LOGDIR=/mnt/speakeasy/library/logs/Oberon/PBR_Bkup_$TODAY.$DATE.log
LOGDIR=$SURCE/"PBR_Bkup_"$TODAY.$DATE".log"
#echo "LOGDIR:" $LOGDIR

EmailAddress="YourEmailAddress"

#echo ''
#echo ''


# JOB AND EXCLUSION FILES ------------------------------------------------------------------

rm $DEST/jobs.txt
cd $SURCE
ls --format=single-column > $DEST/jobs.txt

file=$DEST/jobs.txt
exclusion=$DEST/exclusion_list.txt # Use this to exclude folders from being bkup'd up

#echo $file
#echo $exclusion
# ------------------------------------------------------------------------------------------


#echo ''
#echo ''


# BUILD EXCLUSION ARRAY FROM "exclusion_list.txt" FILE (PRE-BUILT) ------------------
ExAry=()

#LOOP
while IFS= read -r line
	do
	#echo $line
	ExAry=( "${ExAry[@]}"  $line )
done < $exclusion

#echo ${ExAry[*]}
# ------------------------------------------------------------------------------------------


#echo ''
#echo ''


# BUILD JOB ARRAY FROM "job.txt" FILE (BUILT AUTOMATICALLY FROM "LS") ----------------------
JobAry=()

#LOOP
while IFS= read -r line
	do
	#echo $line
	JobAry=( "${JobAry[@]}"  $line )
done < $file

#echo ${JobAry[*]}
# ------------------------------------------------------------------------------------------


#echo ''
#echo ''


# BUILD JOB BACK UP LIST FROM JOBS AND EXCLUSIONS  ----------------------------------------
a=0
aT=${#JobAry[*]} #LENGTH OF ARRAY

while (($a <= $aT))
do
	JobAry=( ${JobAry[@]#${ExAry[$a]}} )
	#echo $a
	a=$(( a+1 ))
done

#echo "Job Backup List:" ${JobAry[*]}
# ------------------------------------------------------------------------------------------


#echo ''
#echo ''


# VARIABLES --------------------------------------------------------------------------------

Grab_Date() {
	# DECLARES NUMERICAL VALUE FOR THE DAY OF THE WEEK.
	# 	NOTE: BE SURE TO OFFSET FOR THE ARRAY VALUES
	# 	STARTS AT '1' = 'MONDAY'
	NUMDAYOFWEEK=`date +%u`
	#echo "NUMDAYOFWEEK:" $NUMDAYOFWEEK

	# DECLARES DAYS OF THE WEEK ARRAY
	Days=(Mon Tue Wed Thu Fri Sat Sun)

	# DECALRES WHAT DAY OF THE WEEK YESTERDAY WOULD BE
	# DEFAULT OFFSET = -2
	if [ "$NUMDAYOFWEEK" == "1" ]; then
		YESTERDAY=${Days[$NUMDAYOFWEEK+5]}
		#echo "A YESTERDAY:" $YESTERDAY
	else 
		YESTERDAY=${Days[$NUMDAYOFWEEK-2]}
		#echo "B YESTERDAY:" $YESTERDAY
	fi

	# DECALRES WHAT DAY OF THE WEEK TODAY WOULD BE
	# DEFAULT OFFSET = -1
	TODAY=${Days[$NUMDAYOFWEEK-1]}
	#echo "TODAY:" $TODAY

	# DECALRES DATE USING TWO DIGITAL REPRESENTATION (e.g 10.14.09)
	DATE=`date +%m.%d.%y`
	#echo "TODAY:" $TODAY

	TIME=`date +%T`
	#echo "TIME:" $TIME
}

Grab_Date


# ------------------------------------------------------------------------------------------





echo " " >> $LOGDIR
echo "--------------------------------------------------------------------------------------------------" >> $LOGDIR
echo "--------------------------------- Nightly Back up Initialization ---------------------------------" >> $LOGDIR
echo "--------------------------------------------------------------------------------------------------" >> $LOGDIR
echo " " >> $LOGDIR
echo "Start Date: $TODAY $DATE" >> $LOGDIR
echo "Start Time: $TIME" >> $LOGDIR
echo " " >> $LOGDIR
echo "Log Name: $LOGDIR" >> $LOGDIR
echo " " >> $LOGDIR
echo "Jobs to be backed up:" >> $LOGDIR

for pj in ${JobAry[*]}
do
	echo "    " $pj >> $LOGDIR
done
# --------
echo " " >> $LOGDIR





# CP SCRIPT --------------------------------------------------------------------------------

COMMANDS=-fpruv
#COMMANDS=-dpRuv
#cp $COMMANDS $SURCEJOB $DESTJOB >> $LOGDIR


for j in ${JobAry[*]}
do
	#echo $j
	SURCEJOB=$SURCE/$j/*
	#echo $SURCEJOB

	DESTJOB=$DEST/$j/
	#echo $DESTJOBecho "Start Date: $TODAY $DATE" >> $LOGDIR

	if [ ! -d $DESTJOB ]; then
		echo $DESTJOB "doesn't exist"
		mkdir $DESTJOB
	fi	
	
	echo "SNAPSHOT DATE & TIME:" $DATE $TIME >> $LOGDIR
		
	cp $COMMANDS $SURCEJOB $DESTJOB >> $LOGDIR

	#echo $COMMANDS $SURCEJOB $DESTJOB
	
done
# ------------------------------------------------------------------------------------------

Grab_Date

echo " " >> $LOGDIR
echo "--------------------------------------------------------------------------------------------------" >> $LOGDIR
echo "--------------------------------- Nightly Back up Complete! ---------------------------------" >> $LOGDIR
echo " " >> $LOGDIR
echo "End Date: $TODAY $DATE" >> $LOGDIR
echo "End Time: $TIME" >> $LOGDIR
echo "--------------------------------------------------------------------------------------------------" >> $LOGDIR
echo " " >> $LOGDIR




# EMAIL ------------------------------------------------------------------------------------

# email subject
SUBJECT="Nightly Back Up"

# Email To ?
EMAIL=$EmailAddress

# Email text/message
EMAILMESSAGE="/tmp/emailmessage.txt"

echo -e "NIGHTLY BACK UP REPORT:" > $EMAILMESSAGE
echo -e "DATE:" $DATE >> $EMAILMESSAGE 
echo -e "TIME:" $TIME >> $EMAILMESSAGE
echo -e "------------------------------------------------\n" >> $EMAILMESSAGE

echo "CURRENT JOBS BACKED UP: " >> $EMAILMESSAGE

a=0
aT=${#JobAry[*]} #LENGTH OF ARRAY
while (($a <= $aT))
do
	echo ${JobAry[$a]} >> $EMAILMESSAGE
	a=$(( a+1 ))
done

echo -e " "  >> $EMAILMESSAGE

echo "LOG SIZE & PATH: " >> $EMAILMESSAGE
ls -sh $LOGDIR >> $EMAILMESSAGE

echo -e " "  >> $EMAILM
# send an email using /bin/mail
cat $0 | mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
exit 0
# ------------------------------------------------------------------------------------------





echo " " >> $LOGDIR
echo "--- Email Sent ---" >> $LOGDIR
echo " " >> $LOGDIRESSAGEls -1 | grep -v "^.kde$" | xargs -n 1 -iHERE cp -R HERE <destination


echo -e "DISK SPACE:" >> $EMAILMESSAGE

df -Ph $DEST >> $EMAILMESSAGE
df -Ph $SURCE >> $EMAILMESSAGE

 
