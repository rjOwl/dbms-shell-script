#!/usr/bin/bash

#entry poin to the database engine

typeset -i schema=`find Database-schema 2> /dev/null | wc -l`
if [ $schema -eq 0 ]
then
	mkdir Database-schema
fi

cd Database-schema

function createNewDatabase {
	echo __________________________________________________________________
	while true
	do
		read -p "please write the name of new Databese: " newDatabaseName
		typeset -i checkOnDatabase=`find $newDatabaseName 2> /dev/null | wc -l`
		if [ $checkOnDatabase -eq 1 ]
		then
			echo -e "\e[31mThis database is already exist, please rewrite the name.\e[0m"
		elif [[ $newDatabaseName == $EOF ]]
		then
			echo " "
			break
		else
			mkdir $newDatabaseName
			echo your database has been created successfully.
			break
		fi

	done
	echo __________________________________________________________________ 
}

function listDatabases  {
	echo __________________________________________________________________
	typeset databaseList=`ls`
	if [ $databaseList -eq 0 ]
	then 
		echo -e "\e[31mNo Database exist yet.\e[0m"
	else
		for i in $databaseList
		do
			echo $i
		done
	fi
	echo __________________________________________________________________
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
		*) echo -e "\e[31mWrong choice! please choose from the above choices.\e[0m" ;;
	esac
	echo $'1) Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'


done


