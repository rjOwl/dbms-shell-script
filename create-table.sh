#!/bin/bash

#variables section
. globals.sh

typeset -i endCreationFlag=1
typeset -i numberOfcolumnCreation=0
typeset -i columnPrimaryKeyCreation=0
typeset -i printLineCreation=0
columnNames=""
columnDatatype=""

#function to check if the table is exist
function thisCheckOnTableCreation(){
	read -p "please insert table name to be created: " tableName
	while [ -f $tableName ] 
	do
		echo -e "\e[31mThe table name already exist, please insert another name.\e[0m"
		read -p "please insert table name: " tableName
	done 
}

#function to create table in new file if the user insertion has been finished with number of columns 
function saveTable(){
	if [ $numberOfcolumnCreation -eq 0 ]
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
		echo $columnPrimaryKeyCreation >> .$tableName
		echo -e "\e[32mthe $tableName has been created successfully.\e[0m"
		echo "----------------------------------------------------------------------------"
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

#show the last columns with datatype to the user while adding new column.
function tableViewCreation(){
	zenityVar=""
	if [[ $numberOfcolumnCreation != 0 ]]
	then
		typeset -i j=0
		while [ $j -lt $printLineCreation ] 
		do
			zenityVar+="-"
			let "j++"
		done
		zenityVar+="\n"
		for i in ${arrayOfColumnName[*]}
		do
			zenityVar+="  $i  |"
		done
		zenityVar+="\n"
		j=0
		while [ $j -lt $printLineCreation ]
		do
			zenityVar+="-"
			let "j++"
		done
		zenityVar+="\n"
		zenity --entry --title="last Columns" --text=$zenityVar

	fi
}

#ask the user to insert valid datatype (INT - STRING - DATE) for the new record
function getColumnDatatypeCreation(){
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
	(( printLineCreation = $printLineCreation + 5 + ${#newColumnName} + ${#Type} ))
	arrayOfColumnName[${numberOfcolumnCreation}]="$newColumnName$Type"
}

#ask the user about the primary key
function getPrimaryKeyCreation(){
	if [[ $columnPrimaryKeyCreation == 0 ]]
	then
		read -p "Do you want this key to be your primary key [Y/n]: " newcolumnPrimaryKeyCreation
		if [ $newcolumnPrimaryKeyCreation != N -a $newcolumnPrimaryKeyCreation != n ]
		then 
			(( columnPrimaryKeyCreation = numberOfcolumnCreation ))			
		fi
	fi
}

#function to create new table in current database
function createTable() {
	#clear
	echo ----------------------------------------------------------------------------
	thisCheckOnTableCreation
	while [[ $endCreationFlag == 1 ]]
	do
		userChoice=`zenity --entry --title="Creation of new Database" --text='1) Add new column.\n2) Create table with at least one column.\n3) Exit without save.\n'`
		echo ----------------------------------------------------------------------------
		echo "1) Add new column."
		echo "2) Create table with at least one column."
		echo "3) Exit without save."

		read -p "please insert your choice: " userChoice
		if [[ $userChoice == 1 ]]
		then
			addDelimiterToRecordCreation
			tableViewCreation
			read -p "please insert new column name: " newColumnName
			columnNames+=$newColumnName
			getColumnDatatypeCreation
			let "numberOfcolumnCreation++"
			getPrimaryKeyCreation
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
