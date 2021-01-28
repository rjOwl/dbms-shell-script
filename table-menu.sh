#!/bin/bash

#interface with tables.
. ./create-table.sh
. ./delete-from-table.sh
. ./update-table.sh
. dml.sh

function tableMenu() {
clear
echo instructions here
echo ----------------------------------------------------------------------------
PS3="Please inser your choice: "
select tableChoice in $'Create Table.zz\n2) List Tables.\n3) Drop Table.\n4) Insert into Table.\n5) Select From Table.\n6) Delete From Table.\n7) Update Table.\n8) return to database schema to change used database.'
do
	case $REPLY in
		1) createTable;;
		2) listTables ;;
		3) read -p "Table name to drop> " table_name
			dropTable $table_name
			;;
		4) read -p "Table name to insert into> " table_name
			insertIntoTable $table_name
		;;
		5) read -p "Table name to select from> " table_name
			local columns_names=($(head -n 1 .$table_name | tr $DELIMITER ' '))
			local pkColNum=$(tail -n 1 .$table_name )
			# echo $length ${columns_names[1]} ${columns_types[1]} $pkColNum
			local new_record=()
			echo -----------------------------------------
			echo "-----------------$table_name----------------"
			echo `head -n 1 .$table_name | tr $DELIMITER '   |   '`
			echo -----------------------------------------
			echo -----------------------------------------
			echo "           ${columns_names[0]}  ${columns_names[1]}"
			echo -----------------------------------------
			read -p "Insert your column(s) separated by spaces> " columns
			col_arr=($columns)
			read -p "Insert your where condition> " condition
			#   ${columns_names[@]} $table_name)
			selectFromTable col_arr columns_names $table_name
			;;
		6) deleteFromTable ;;
		7) updateTable ;;
		8) echo to 'return' to schema Sto change database
		   cd ;;
	    	*) echo -e "\e[31mWrong choice! please choose from the above choices.\e[0m"
		   echo ------------------------------------------------------------------------ ;;
	esac
	echo $'1) Create Table.\n2) List Tables.\n3) Drop Table.\n4) Insert into Table.\n5) Select From Table.\n6) Delete From Table.\n7) Update Table.\n8) return to database schema to change used database.'
done
}
