#!/bin/bash

# Returns 1 if the directory exists and -1 if it doesn't
function exist(){
    if [ -d $1 ]
    then 
        echo 1
    else
        echo -1
    fi
}

function useDb(){
    dbDir=$1
    currDir=$($"pwd")
    databsePath = $currDir"/$dbDir"
    echo $databsePath
}

function isDbEmpty(){
	contents="$(ls -A $1)"
	if [ ! $contents ]
	 then
	  echo 1
	else
	  echo -1
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

