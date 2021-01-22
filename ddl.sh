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
    databsePath = $($"pwd")"/$dbDir"
    echo $databsePath
}

function dbStatus(){
	contents="$(ls -A $1)"
	if [ $contents ]
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


# how to use
# $1 should be user input
f=$( exist "$1" )
echo $f
if [ $f -eq 1 ]
	then 
		#f=$($"pwd")"/$1"
		dbPath=$(useDb "$1")
		isEmpty=$(dbStatus "$1")
		if [ ! $isEmpty ]
		then	rm "-d" $dbPath
		else
			echo "It's not empty. Do you want to remove the database with its tables? [N/y]"
			read ch
			if [ $ch = y ]
				then rm "-dr" $dbPath
			else
				echo
			fi
		fi
	else
	 echo "No"
fi


