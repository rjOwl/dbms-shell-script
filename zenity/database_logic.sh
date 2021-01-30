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
		zenity --warning --title="List of Databases" --text="No Database exists yet."
	else
		zenity --list \
		  --title="List of Databases" \
		  --column="Database Names" \
		  `ls -1`
	fi
}



function connectDb(){
	echo ------------------------------------------------------------------------
	#echo "  "
    read -p "DB name> " db_name
    dbExist $db_name
    dbExist=$?
    if [ $dbExist -eq 1 -a ${#db_name} -gt 0 ]
    then
        useDb $db_name
        echo -e "[] Connection established"
		tableMenu;
    else echo -e "\033[31m[X]\e[0m Database dosen't exist!"
    fi
	#echo "  "
	echo ------------------------------------------------------------------------
}


function dropDb(){
	echo ------------------------------------------------------------------------
	#echo "  "
	read -p "DB name> " db_name
	dbExist $db_name
	dbExist=$?
	if [ $dbExist -eq 1 ]
	then
		isDbEmpty $db_name
		isEmpty=$?
		if [ $isEmpty -eq 1 ]
		then
			echo "Empty schema"
		        rm "-dr" $db_name
		        echo "Removed database successfully;"
		else
		        echo "Database is not empty. Do you want to remove the database with its tables? [N/y]"
		        read ch
		        if [ $ch = y ]
		            then 
		                rm "-dr" $db_name
		                echo "Removed"
		        else
		            echo
		        fi
		fi
	else
		echo -e "\033[31m[X]\e[0m No database with this name found."
	fi
	#echo "  "
	echo ------------------------------------------------------------------------
}








