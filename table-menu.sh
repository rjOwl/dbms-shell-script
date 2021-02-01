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
	tableChoice=`zenity --list --text "Table Actions"  --radiolist  --column "Pick" --column "Menu" FALSE "Create Table" FALSE "List Tables" FALSE "Drop Table" FALSE "Insert into Table" FALSE "Select From Table" FALSE "Delete From Table" FALSE "Update Table" FALSE "Return"`
	# tableChoice=`zenity --list --text "Welcome to OurSQL" --radiolist  --column "Pick" --column "Menu"    FALSE "Create Database" FALSE  "List Database" FALSE  "Connect to Databases" FALSE "Drop Database" FALSE "Exit"`

	if [[ $? -eq 1 ]]
	then
		break
	fi
	case $tableChoice in
		# 1) createTable ;;
		# 2) listTables ;;
		# 3) dropTable ;;
		# 4) insertIntoTable;;
		# 5) selectFromTable ;;
		# 6) deleteFromTable ;;
		# 7) updateTable ;;
		# 8) echo 'Return'
		#    cd ..
		#    break ;;
		"Create Table") createTable ;;
		"List Tables") listTables ;;
		"Drop Table") dropTable ;;
		"Insert into Table") insertIntoTable ;;
		"Select From Table") selectFromTable ;;
		"Delete From Table") deleteFromTable ;;
		"Update Table") updateTable ;;
		"Return")
		   cd ..
		   break ;;
		*) zenity --warning --title="Table Options" --width="500" --height="100" --text="Wrong choice! please choose from the above choices."
	esac
done
}
