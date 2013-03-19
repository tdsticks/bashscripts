#!/bin/bash

# WEB SERVER BACKUP (USING BASH SHELL & WGET)
# VER 2.0
# WRITTEN BY: TD STEVE STICKEL
# DATE: 10.21.09
# 
# CREATES DATED DIRECTORY, TRIGGERS WGET AND THEN FIRES OFF AN EMAIL 
# WITH A LIST OF WHAT WAS BACKED UP
# 
# YOU'LL NEED TO ADD YOUR FTP CREDENTIALS TO THE WGET COMMAND
# ALSO, CHANGE THE VARIABLES BELOW TO MEET YOUR PATHING NEEDS



# VARIABLES ******************************************************************************


EmailAddress="YourEmailAddress"

# Destination Path
#DEST=/media/WAT_ARCH/web_backup
DEST=/Volumes/"drive name"

# LOG DIRECTORY AND FILENAME *************************************************************
LOGDIR=/mnt/speakeasy/library/logs/web_server_backup/${ThisWeek}_$DATE.log
echo "LOGDIR:" $LOGDIR







# DECLARES NUMERICAL VALUE FOR THE DAY OF THE WEEK.
# 	NOTE: BE SURE TO OFFSET FOR THE ARRAY VALUES
# 	STARTS AT '1' = 'MONDAY'
NUMDAYOFWEEK=`date +%u`
echo "NUMDAYOFWEEK:" $NUMDAYOFWEEK

# DECLARES DAYS OF THE WEEK ARRAY
Days=(Mon Tue Wed Thu Fri Sat Sun)

# DECALRES WHAT DAY OF THE WEEK TODAY WOULD BE
# DEFAULT OFFSET = -1
TODAY=${Days[$NUMDAYOFWEEK-1]}
echo "TODAY:" $TODAY

# DECALRES DATE USING TWO DIGITAL REPRESENTATION (e.g 10.14.09)
DATE=`date +%m.%d.%y`
echo "DATE:" $DATE

L4W=8*4
LW=8

DoY=`date +%j`
echo "Day of the Year:" $DoY

DoYLW=$(($DoY-$LW))
echo "DoY Last Week:" $DoYLW

DoYL4W=$(($DoY-$L4W))
echo "DoY 4 Weeks Ago:" $DoYL4W

FourWeeksAgo=${TODAY}_$DoYL4W
LastWeek=${TODAY}_$DoYLW
ThisWeek=${TODAY}_$DoY

cd $DEST



# THIS WILL REMOVE OLDER BACKUPS BEWARE OF WHAT THIS DOES
#if [ -d $FourWeeksAgo ]; then
#	echo $FourWeeksAgo "exist... removing!"
#	rm -r $FourWeeksAgo
#fi
#echo "Removed " $FourWeeksAgo



mkdir $ThisWeek

# CANNOT MAKE HARDLINKS *DISABLED PURPOSELY
#cp -al -v $LastWeek/* $ThisWeek/

cd $ThisWeek/

# User this to exclude folders from backing up
# otherwise leave blank
#ExcludeDir="/folder1,/folder2" 
ExcludeDir="" 


# WGET ***********************************************************************************
wget --mirror -c --exclude-directories=$ExcludeDir --output-fil=$LOGDIR --ftp-user="ftpUsername" --ftp-password="ftpPassword" ftp://ftp."ftpDomain".com/






# EMAIL --------------------------------------------------------------------------

# email subject
SUBJECT="Website Back Up"

# Email To ?
EMAIL=$EmailAddress

# Email text/message
EMAILMESSAGE="/tmp/webemailmessage.txt"

echo -e "WEBSITE BACK UP REPORT:" > $EMAILMESSAGE
echo -e "DATE:" $DATE >> $EMAILMESSAGE
echo -e "------------------------------------------------\n" >> $EMAILMESSAGE

echo "LOG SIZE & PATH: " >> $EMAILMESSAGE
ls -sh $LOGDIR >> $EMAILMESSAGE

echo -e " "  >> $EMAILMESSAGE

echo -e "OVERALL DISK SPACE:" >> $EMAILMESSAGE
df -Ph /media/WAT_ARCH >> $EMAILMESSAGE

# send an email using /bin/mail
cat $0 | mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
exit 0


#	-m,  --mirror			shortcut for -N -r -l inf --no-remove-listing.
#		-N,  --timestamping     don't re-retrieve files unless newer than local.
#		-r,  --recursive	pecify recursive download.
#		-l,  --level=NUMBER	maximum recursion depth (inf or 0 for infinite).
	
#	-o,  --output-file=FILE		log messages to FILE
#	-q,  --quiet			quiet (no output).
#	-nc, --no-clobber		skip downloads that would download to existing files.
#	-c,  --continue			resume getting a partially-downloaded file.
#	-X,  --exclude-directories=LIST list of excluded directories.
#	--ftp-user=USE			set ftp user to USER.
#	--ftp-password=PASS		set ftp password to PASS.
       
