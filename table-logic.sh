#!/bin/bash

#interface with tables.
clear
read -p "please insert table name: " tableName
typeset -i endCreation=0
typeset -i numberOfcolumn=0
columnNames=""
columnDatatype=""
typeset -i columnPrimaryKey=0
while [ $endCreation -eq 0 ]
do

	echo ----------------------------------------------------------------------------
	echo press 1 to add new column.
	echo press 0 to create table with at least one column.
	read -p "please insert your choice: " userChoice
	if [[ $userChoice == 0 ]]
	then
		if [ $numberOfcolumn -eq 0 ]
		then
			echo -e "\e[31mNo column in the table, so this table will not be created.\e[0m"
			read -p "Are you sure that you want to cancel table creation process [y/any key]: " SureChoice
			if [ $SureChoice = y -o $SureChoice = Y ]
			then 
				break 
			else
				continue			
			fi
		else
		touch $tableName
		## creation
		break;
		fi
	elif [[ $userChoice == 1 ]]
	then
		if [[ $numberOfcolumn != 0 ]]
		then
			columnName+="||"
			columnDatatype+="||"
		fi

		read -p "please insert new column name: " newColumnName
		columnName+=$newColumnName
		read -p "please insert new column datatype: " newColumnDatatype
		columnDatatype+=$newColumnDatatype
		let "numberOfcolumn++"
		if [[ $columnPrimaryKey == 0 ]]
		then
			read -p "Do you want this key to be your primary key [y/any key]: " newColumnPrimaryKey
			if [ $newColumnPrimaryKey = y -o $newColumnPrimaryKey = Y ]
			then 
				(( columnPrimaryKey = numberOfcolumn ))			
			fi
		fi	
	else
		"\e[31mWrong choice.\e[0m"
	fi		 
done

