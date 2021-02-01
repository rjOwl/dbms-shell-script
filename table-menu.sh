#!/bin/bash

#interface with tables.
. ./create-table.sh
. ./delete-from-table.sh
. ./update-table.sh
. ./dml.sh
. ./select-from-table.sh

function tableMenu() {
while true
do
	tableChoice=`zenity --entry --title="Table Options" --text='1) Create Table.\n2) List Tables.\n3) Drop Table.\n4) Insert into Table.\n5) Select From Table.\n6) Delete From Table.\n7) Update Table.\n8) return to database schema to change used database.'`
	if [[ $? -eq 1 ]]
	then
		break
	fi
	case $tableChoice in
		1) createTable ;;
		2) listTables ;;
		3) dropTable ;;
		4) insertIntoTable ;;
		5) selectFromTable ;;
		6) deleteFromTable ;;
		7) updateTable ;;
		8) echo to 'return' to schema to change database
		   cd ..
		   break ;;

		"Create Table") createTable ;;
		"List Tables") listTables ;;
		"Drop Table") dropTable ;;
		"Insert into Table") insertIntoTable ;;
		"Select From Table") selectFromTable ;;
		"Delete From Table") deleteFromTable ;;
		"Update Table") updateTable ;;
		"return") echo to 'return' to schema to change database
		   cd ..
		   break ;;
	    	*) zenity --warning --title="Table Options" --width="500" --height="100" --text="Wrong choice! please choose from the above choices."
	esac
done
}
