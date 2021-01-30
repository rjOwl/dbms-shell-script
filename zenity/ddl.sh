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







# Returns 1 if database empty else -1
#function isDbEmpty(){
#	pwd
#	contents="$(ls -A $1)"
#	if [ ! $contents ]
#	 then
#	  return 1
#	else
#	  return -1
#	fi
#}



#function isInUse(){
#    inUseDbPath=$1
#   if [[ $PWD == $inUseDbPath ]]
#   then
#       return 1
#   else
#       return -1
#   fi
#}



#function renameDb(){
#   dbName=$1
#   new_name=$2
#   mv $dbName $new_name
#}





