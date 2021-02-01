#!/bin/bash

. ddl.sh
. dml.sh
. table-menu.sh

function createNewDatabase(){
	while true
	do
 		newDatabaseName=`zenity --entry --title="Database creation" --text="please write the name of new Databese"`
		if  [[ $? == 1 ]]
		then
			break
		fi
		dbExist $newDatabaseName
		checkOnDatabase=$?
		if [ $checkOnDatabase -eq 1 ]
		then
			newDatabaseName=`zenity --entry --title="Database creation" --text="This database already exist, please rewrite the name."`
			if  [[ $? == 1 ]]
			then
				break
			fi
		else
			mkdir $newDatabaseName
			mkdir $newDatabaseName'/.trash'
			zenity --notification --title="Database creation" --text="The New Database has been created successfully."
			break
		fi
	done
}

function listDatabases () {

	typeset databaseList=`ls | wc -l`
	if [ $databaseList -eq 0 ]
	then 
		zenity --warning --title="List of Databases" --width="500" --height="100" --text="No Database exists yet."
	else
		zenity --list \
		  --title="List of Databases" \
		  --column="Database Names" \
		  `ls -1`
	fi
}



function connectDb(){
    db_name=`zenity --entry --title="Drop Database" --text="please write the name Databese to connect with"`
    dbExist $db_name
    dbExist=$?
    if [ $dbExist -eq 1 -a ${#db_name} -gt 0 ]
    then
        useDb $db_name
	zenity --notification --title="Drop Database" --text="[] Connection established"
	tableMenu;
    else
	zenity --warning --title="List of Databases" --width="500" --height="100" --text=" Database dosen't exist!"
    fi
}


function dropDb(){
	db_name=`zenity --entry --title="Drop Database" --text="please write the name of new Databese"`
	dbExist $db_name
	dbExist=$?
	if [ $dbExist -eq 1 ]
	then
		isDbEmpty $db_name
		isEmpty=$?
		if [ $isEmpty -eq 1 ]
		then
		        rm "-dr" $db_name
			zenity --notification --title="Drop Database" --text="Empty schema.\nDatabase has been dropped successfully."
		else
			zenity --question --title="Drop Database" --width="500" --height="100" --ok-label="Yes" --cancel-label="No" --text="Database is not empty. Do you want to remove the database with its tables?"
		        if [[ $? == 0 ]]
		            then 
		                rm "-dr" $db_name
		                zenity --notification --title="Drop Database" --text="Database has been dropped successfully."
		        fi
		fi
	else
		zenity --warning --title="List of Databases" --width="500" --height="100" --text="No Database with this name."
	fi
}








