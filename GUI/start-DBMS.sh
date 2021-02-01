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
	userChoice=`zenity --list --text "Welcome to OurSQL" --radiolist  --column "Pick" --column "Menu"    FALSE "Create Database" FALSE  "List Database" FALSE  "Connect to Databases" FALSE "Drop Database" FALSE "Exit"`
	echo $?
	if [[ $? -eq 1 ]]
	then
		break
	fi
	case $userChoice in
	    "Create Database") createNewDatabase ;;
	    "List Database") listDatabases ;;
	    "Connect to Databases") connectDb ;;
	    "Drop Database") dropDb ;;
	    "Exit") break;
	esac
done






