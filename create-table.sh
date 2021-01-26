#!/bin/bash

#variables section
DELIMITER=";;"
typeset -i endCreationFlag=1
typeset -i numberOfcolumn=0
typeset -i columnPrimaryKey=0
typeset -i printLine=0
columnNames=""
columnDatatype=""

#function to check if the table is exist
function checkOnTable(){
	read -p "please insert table name: " tableName
	while [ -f $tableName ] 
	do
		echo -e "\e[31mThe table name already exist, please insert another name.\e[0m"
		read -p "please insert table name: " tableName
	done 
}

#function to create table in new file if the user insertion has been finished with number of columns 
function saveTable(){
	if [ $numberOfcolumn -eq 0 ]
	then
		echo -e "\e[31mNo column in the table, so this table will not be created.\e[0m"
		read -p "Are you sure that you want to cancel the table creation process [Y/n]: " SureChoice
echo $SureChoice
		if [ $SureChoice != N -a $SureChoice != n ]
		then 
			endCreationFlag=0
			echo "----------------------------------------------------------------------------"			
		fi
	else
		touch .$tableName
		touch $tableName
		echo $columnNames >> .$tableName
		echo $columnDatatype >> .$tableName
		echo $columnPrimaryKey >> .$tableName
		echo "----------------------------------------------------------------------------"
		endCreationFlag=0
	fi
}

#add Delimiter between columns after the first column
function addDelimiterToRecord(){
	if [[ $numberOfcolumn != 0 ]]
	then
		columnNames+=$DELIMITER
		columnDatatype+=$DELIMITER
	fi
}

#show the last columns with datatype to the user while adding new column.
function tableView(){
	if [[ $numberOfcolumn != 0 ]]
	then
		typeset -i j=0
		while [ $j -lt $printLine ] 
		do
			printf "-"
			let "j++"
		done
		echo " "
		for i in ${arrayOfColumnName[*]}
		do
			printf "  $i  |"
		done
		echo " "
		j=0
		while [ $j -lt $printLine ]
		do
			printf "-"
			let "j++"
		done
		echo " "
	fi
}

#ask the user to insert valid datatype (INT - STRING - DATE) for the new record
function getColumnDatatype(){
	while true
	do
		echo "1) Integar."
		echo "2) String."
		echo "3) Date."
		read -p "please insert new column datatype: " newColumnDatatype
		if [ $newColumnDatatype == 1 ]
		then
			columnDatatype+="INT"
			Type="(INT)"
			break
		elif [ $newColumnDatatype == 2 ]
		then
			columnDatatype+="STRING"
			Type="(STRING)"
			break
		elif [ $newColumnDatatype == 3 ]
		then
			columnDatatype+="DATE"
			Type="(DATE)"
			break
		else
			echo -e "\e[31mWrong choice.\e[0m"
		fi
	done
	#calculation on column name and datatype to print the table view next step
	(( printLine = $printLine + 5 + ${#newColumnName} + ${#Type} ))
	arrayOfColumnName[${numberOfcolumn}]="$newColumnName$Type"
}

#ask the user about the primary key
function getPrimaryKey(){
	if [[ $columnPrimaryKey == 0 ]]
	then
		read -p "Do you want this key to be your primary key [Y/n]: " newColumnPrimaryKey
		if [ $newColumnPrimaryKey != N -a $newColumnPrimaryKey != n ]
		then 
			(( columnPrimaryKey = numberOfcolumn ))			
		fi
	fi
}

#function to create new table in current database
function createTable() {
	clear
	checkOnTable
	while [[ $endCreationFlag == 1 ]]
	do

		echo ----------------------------------------------------------------------------
		echo "1) Add new column."
		echo "2) Create table with at least one column."
		echo "3) Exit without save."

		read -p "please insert your choice: " userChoice
		if [[ $userChoice == 1 ]]
		then
			addDelimiterToRecord
			tableView
			read -p "please insert new column name: " newColumnName
			columnNames+=$newColumnName
			getColumnDatatype
			let "numberOfcolumn++"
			getPrimaryKey
		elif [[ $userChoice == 2 ]]
		then
			saveTable
		elif [[ $userChoice == 3 ]]
		then
			echo "----------------------------------------------------------------------------"
			break		
		else
			echo -e "\e[31mWrong choice.\e[0m"
		fi		 
	done
}
createTable
