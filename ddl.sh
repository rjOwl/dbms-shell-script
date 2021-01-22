#!/bin/bash

# Returns 1 if the directory exists and -1 if it doesn't
function dbExist(){
    if [ -d $1 ]
    then 
        return 1
    else
        return -1
    fi
}

function useDb(){
    dbDir=$1
    inUseDbPath="$PWD/$dbDir"
    cd $dbDir
	echo $inUseDbPath
}

# Returns 1 if database empty else -1
function isDbEmpty(){
	pwd
	contents="$(ls -A $1)"
	if [ ! $contents ]
	 then
	  return 1
	else
	  return -1
	fi
}

function isInUse(){
    inUseDbPath=$1
    if [[ $PWD == $inUseDbPath ]]
    then
        return 1
    else
        return -1
    fi
}

function dropDb(){
    options=$1
    dbName=$2
    rm $options $dbName
}

function renameDb(){
    dbName=$1
    new_name=$2
    mv $dbName $new_name
}

