#!/usr/bin/bash

#entry poin to the database engine

if [ ! -d Database-schema ]
then
	mkdir Database-schema
fi

cd Database-schema
echo " Welcome"
echo ------------------------------------------------------------------------

function createNewDatabase {
	echo ------------------------------------------------------------------------
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
			echo your database has been created successfully.
			break
		fi

	done
	echo ------------------------------------------------------------------------
}

function listDatabases  {
	echo ------------------------------------------------------------------------
	typeset databaseList=`ls | wc -l`
	if [ $databaseList -eq 0 ]
	then 
		echo -e "\e[31mNo Database exists yet.\e[0m"
	else
		echo List of Databases:
		ls -1
	fi
	echo ------------------------------------------------------------------------
}

PS3="please enter your choice: "
select userChoice in $'Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'
do
	case $REPLY in 
		1) createNewDatabase ;;
		2) listDatabases ;;
		3) ;;
		4) ;;
		5) break;;
		*) echo -e "\e[31mWrong choice! please choose from the above choices.\e[0m"
		   echo ------------------------------------------------------------------------ ;;
	esac
	echo $'1) Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'
done


