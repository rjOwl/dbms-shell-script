#!/bin/bash

. ddl.sh
. dml.sh
. table-menu.sh

function createNewDatabase(){
	echo ------------------------------------------------------------------------
	echo "  "
	while true
	do
		read -p "please write the name of new Databese: " newDatabaseName
		#typeset -i checkOnDatabase=`find $newDatabaseName 2> /dev/null | wc -l`
		dbExist $newDatabaseName
		checkOnDatabase=$?
		if [ $checkOnDatabase -eq 1  ]
		then
			echo -e "\e[31mThis database already exist, please rewrite the name.\e[0m"
		elif  [[ $newDatabaseName == $EOF ]]

		then
			echo " "
			break
		else
			mkdir $newDatabaseName
			mkdir $newDatabaseName'/.trash'
			echo your database has been created successfully.
			break
		fi
	done
	echo "  "
	echo ------------------------------------------------------------------------
}

function listDatabases () {
	echo ------------------------------------------------------------------------
	echo "  "
	typeset databaseList=`ls | wc -l`
	if [ $databaseList -eq 0 ]
	then 
		echo -e "\e[31mNo Database exists yet.\e[0m"
	else
		echo List of Databases:
		ls -1
	fi
	echo "  "
	echo ------------------------------------------------------------------------
}


function connectDb(){
	echo ------------------------------------------------------------------------
	echo "  "
    read -p "DB name> " db_name
    dbExist $db_name
    dbExist=$?
    if [ $dbExist -eq 1 ]
    then
        useDb $db_name
        echo -e "[] Connection established"
		tableMenu;
    else echo -e "\033[31m[X]\e[0m Database dosen't exist!"
    fi
	echo "  "
	echo ------------------------------------------------------------------------
}


function dropDb(){
	echo ------------------------------------------------------------------------
	echo "  "
    read -p "DB name> " db_name
    dbExist $db_name
    dbExist=$?
    isInUse $db_name
    isInUse=$?
    if [ $dbExist -eq 1 ]
        then
            dbPath=$(useDb $db_name)
            #dbPath=$?
            isDbEmpty $dbPath
            isEmpty=$?
            if [ $isEmpty -eq 1 ]
            then
                echo "Empty schema;"
                rm "-d" $dbPath
                echo "Removed database successfully;"
            else
                echo "DB not empty. Do you want to remove the database with its tables? [N/y]"
                read ch
                if [ $ch = y ]
                    then 
                        rm "-dr" $dbPath
                        echo "Removed"
                else
                    echo
                fi
            fi
        else
            echo -e "\033[31m[X]\e[0m No database with this name found."
    fi
	echo "  "
	echo ------------------------------------------------------------------------
}




