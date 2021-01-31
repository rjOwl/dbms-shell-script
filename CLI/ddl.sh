#!/bin/bash

# Returns 1 if the directory exists and -1 if it doesn't
#creation - connection - drop
function dbExist(){
    if [ -d $1 ]
    then 
        return 1
    else
        return -1
    fi
}

#used with connection database only
function useDb(){
    dbDir=$1
    inUseDbPath="$PWD/$dbDir"
    cd $dbDir
	echo $inUseDbPath
}

#drop only
function isDbEmpty(){
	contents="$(ls -A $1/.trash)"
echo $contents
	if [ ! $contents ]
	then
		rm -d $1/.trash
		contents="$(ls -A $1)"
		if [ ! $contents ]
		then
		  	return 1
		else
			mkdir $1/.trash
		fi
	fi
	return -1
}




