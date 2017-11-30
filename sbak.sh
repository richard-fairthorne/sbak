#!/bin/bash
#    sbak - remote Server BAKups - quick and easy
#    Copyright (C) 2009 HashBang Media
#    http://www.hashbang.info
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ########################################################################

# Set usage text
USAGE="

Usage: $(basename $0) [<options>] <host>

Options:

  -b <bandwidth-limit>    - in kB/s default is 0 or no bandwidth limit
  -d <backup-directory>   - default is ~/.sbak
  -n <number-of-backups>  - default is 10. Try 30 or 40. They don't take much room
  -p [server-nice]        - default is 10. Range from 0 to 20. Higher numbers use
                            less server resources.
  -l <login>              - default is root.

"

# defaults
BACKUP_DIR=~/.sbak
NUM_BACKUPS=10
BWLIMIT=0
NICE_SERVER=10
LOGIN=root

# arguments
while getopts 'b:d:n:p:l:' OPTION
do
	case $OPTION in
		b) BWLIMIT=$OPTARG;;
		d) BACKUP_DIR=$OPTARG;;
		n) NUM_BACKUPS=$OPTARG;;
    p) NICE_SERVER=$OPTARG;;
		l) LOGIN=$OPTARG;;
		?) echo "$USAGE"; exit 2;;
	esac
done
shift $(($OPTIND - 1))

SERVER=$1

if [ "$SERVER" == "" ]
then
	echo "$USAGE"
	exit 3
fi

if [ ! -e $BACKUP_DIR/$SERVER/runpid ]
then
	echo $$ > $BACKUP_DIR/$SERVER/runpid
else
	OLDPID=`cat $BACKUP_DIR/$SERVER/runpid`
        echo "Testing if process $OLDPID is still running..."
	kill -0 $OLDPID
        if [ $? != '0' ]
	then
	        echo "$OLDPID is dead."
	else
		echo "$OLDPID is still running! Exiting."
		exit 1
	fi

fi


echo "sbak: (C)2009 Obstacles Gone Corporation"
echo "Preparing to backup server: $SERVER"
echo "--"
echo

if [ ! -e $BACKUP_DIR/$SERVER ]
then
	echo "Creating backup directory."
	mkdir -p $BACKUP_DIR/$SERVER/backups
fi

if [ ! -e $BACKUP_DIR/$SERVER/exclude ]
then
	echo "Creating empty exclude file."
	>$BACKUP_DIR/$SERVER/exclude
fi

if [ -e $BACKUP_DIR/$SERVER/backups/.new-backup ]
then
	echo "Attempting to resume partial backup"
else
	echo "Making new-backup directory"
	mkdir $BACKUP_DIR/$SERVER/backups/.new-backup
fi
echo

echo "Starting backup."
rsync -avvyz --progress --partial --numeric-ids --bwlimit=$BWLIMIT --exclude-from=$BACKUP_DIR/$SERVER/exclude --delete-after --rsync-path="nice -n $NICE_SERVER rsync" --link-dest=$BACKUP_DIR/$SERVER/backups/1-backups-ago $LOGIN@$SERVER:/ $BACKUP_DIR/$SERVER/bakups/.new-backup >$BACKUP_DIR/$SERVER/backup.log 2>$BACKUP_DIR/$SERVER/error.log

RSYNC_RETURN=$?
if [ $RSYNC_RETURN == 0 ] || [ $RSYNC_RETURN == 24 ]
then
	echo "rsync suceeded with retval $RSYNC_RETURN while backup up $SERVER" >> $BACKUP_DIR/$SERVER/backup.log
        echo "Removing highest numbered backup ($NUM_BACKUPS)"
        rm -rf $BACKUP_DIR/$SERVER/backups/${NUM_BACKUPS}-backups-ago

	for ((i=$NUM_BACKUPS;i>1;i-=1)); do
		o=$((i-1))
		if [ -e "$BACKUP_DIR/$SERVER/backups/$o-backups-ago" ]
		then
			mv $BACKUP_DIR/$SERVER/backups/$o-backups-ago $BACKUP_DIR/$SERVER/backups/$i-backups-ago
		fi
	done

	mv $BACKUP_DIR/$SERVER/.new-backup $BACKUP_DIR/$SERVER/backups/1-backups-ago
	touch $BACKUP_DIR/$SERVER/backups/1-backups-ago
else
	echo "rsync failed with retval $RSYNC_RETURN while backing up $SERVER" >> $BACKUP_DIR/$SERVER/error.log
	echo "Backup did not complete. You may try to resume, or examine $BACKUP_DIR/$SERVER/error.log for more details.";
fi

rm $BACKUP_DIR/$SERVER/runpid
