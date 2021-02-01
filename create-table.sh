#!/bin/bash

#variables section
. globals.sh

typeset -i endCreationFlag=1
typeset -i numberOfcolumnCreation=0
typeset -i columnPrimaryKeyCreation=0
printLineCreation=""
Type=""
columnNames=""
columnDatatype=""


#function to check if the table is exist
function thisCheckOnTableCreation(){
	tableName=`zenity --entry --title="Table Creation" --text="please insert table name to be created."`
	while [ -f $tableName ] 
	do
		zenity --warning --title="Table Creation"  --width="500" --height="100" --text="The table name already exist, please insert another name."
		tableName=`zenity --entry --title="Table Creation"  --text="please insert table name."`
	done 
}

#function to create table in new file if the user insertion has been finished with number of columns 
function saveTable(){
	if [ $numberOfcolumnCreation -eq 0 ]
	then
		zenity --question --title="Table Creation" --width="500" --height="100" --ok-label="Yes" --cancel-label="No" --text="No column in the table, so this table will not be created.\nAre you sure that you want to cancel the table creation process?"
	        if [[ $? == 0 ]]
		then 
			endCreationFlag=0;		
		fi
	else
		touch .$tableName
		touch $tableName
		echo $columnNames >> .$tableName
		echo $columnDatatype >> .$tableName
		echo $columnPrimaryKeyCreation >> .$tableName
		zenity --notification --title="Table Creation" --text="the $tableName has been created successfully."
		endCreationFlag=0
	fi
}

#add Delimiter between columns after the first column
function addDelimiterToRecordCreation(){
	if [[ $numberOfcolumnCreation != 0 ]]
	then
		columnNames+=$DELIMITER
		columnDatatype+=$DELIMITER
	fi
}

#ask the user to insert valid datatype (INT - STRING - DATE) for the new record
function getColumnDatatypeCreation(){
	while true
	do
		newColumnDatatype=`zenity --list --title="Table Creation" --height="300" --column=Menu "Integar" "String" "Date" --text="please insert new column datatype."`
		if [ $newColumnDatatype == Integar ]
		then
			columnDatatype+="INT"
			break
		elif [ $newColumnDatatype == String ]
		then
			columnDatatype+="STRING"
			break
		elif [ $newColumnDatatype == Date ]
		then
			columnDatatype+="DATE"
			break
		else
			zenity --warning --title="Table Creation" --width="500" --height="100"  --text="Wrong choice."
		fi
	done
	#calculation on column name and datatype to print the table view next step
	#printLineCreation=$printLineCreation" --column="$newColumnName
	#Type=$Type" "$columnDatatype
}

#ask the user about the primary key
function getPrimaryKeyCreation(){
	if [[ $columnPrimaryKeyCreation == 0 ]]
	then
		newcolumnPrimaryKeyCreation=`zenity --question --title="Table Creation" --ok-label="Yes" --cancel-label="No" --width="500" --height="100" --text="Do you want this key to be your primary key?"`
	        if [[ $? == 0 ]]
		then 
			(( columnPrimaryKeyCreation = numberOfcolumnCreation ))			
		fi
	fi
}

#function to create new table in current database
function createTable() {
	thisCheckOnTableCreation
	while [[ $endCreationFlag == 1 ]]
	do
		userChoice=`zenity --list --title="Table Creation" --height="300" --width="400" --column=Menu "Add new column." "Create table with at least one column." "Exit without save." --text="please insert new column datatype."`
	        if [[ $? == 1 ]]
		then 
			break		
		fi
		#userChoice=`zenity --entry --title="Table Creation" --text='1) Add new column.\n2) Create table with at least one column.\n3) Exit without save.\n'`
		if [[ $userChoice == "Add new column." ]]
		then
			addDelimiterToRecordCreation
			tableViewCreation
			newColumnName=`zenity --entry --title="Table Creation" --text='please insert new column name.'`
			columnNames+=$newColumnName
			getColumnDatatypeCreation
			let "numberOfcolumnCreation++"
			getPrimaryKeyCreation
		elif [[ $userChoice == "Create table with at least one column." ]]
		then
			saveTable
		elif [[ $userChoice == "Exit without save." ]]
		then
			break		
		else
			zenity --warning --title="Table Creation" --width="500" --height="100"  --text="Wrong choice."
		fi		 
	done
}

