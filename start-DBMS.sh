#!/bin/bash
. database_logic.sh
clear
if [ ! -d Database-schema ]
then
	mkdir Database-schema
fi

cd Database-schema

while true
do
	userChoice=`zenity --entry --title="Welcome to OurSQL" --text='1) Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'`
	if [[ $? -eq 1 ]]
	then
		break
	fi
	case $userChoice in
	    1) createNewDatabase ;;
	    2) listDatabases ;;
	    3) connectDb ;;
	    4) dropDb ;;
	    5) break ;;
	    "Create Database") createNewDatabase ;;
	    "List Database") listDatabases ;;
	    "Connect to Databases") connectDb ;;
	    "Drop Database") dropDb ;;
	    "Exit") break;
	esac
done






