#!/bin/bash

#interface with tables.
. ./create-table.sh
. ./delete-from-table.sh
. ./update-table.sh
function tableMenu() {
clear
echo instructions here
echo ----------------------------------------------------------------------------
PS3="Please inser your choice: "
select tableChoice in $'Create Table.\n2) List Tables.\n3) Drop Table.\n4) Insert into Table.\n5) Select From Table.\n6) Delete From Table.\n7) Update Table.\n8) return to database schema to change used database.'
do
	case $REPLY in
		1) createTable ;;
		2) listTable ;;
		3) dropTable ;;
		4) insertIntoTable ;;
		5) selectFromTable ;;
		6) deleteFromTable ;;
		7) updateTable ;;
		8) echo to 'return' to schema to change database
		   cd ;;
	    	*) echo -e "\e[31mWrong choice! please choose from the above choices.\e[0m"
		   echo ------------------------------------------------------------------------ ;;
	esac
	echo $'1) Create Table.\n2) List Tables.\n3) Drop Table.\n4) Insert into Table.\n5) Select From Table.\n6) Delete From Table.\n7) Update Table.\n8) return to database schema to change used database.'
done
}
tableMenu
