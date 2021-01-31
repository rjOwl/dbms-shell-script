#!/bin/bash

# variables section
. globals.sh

typeset -i index=1

# function to put the column names and column datatype in array to display them to the user to select from them
function getColumnNamesAndDatatypeInArraysInUpdate(){
	columnNameInFile=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	columnDatatypeInFile=`sed -n '2p' .$tableName | sed "s/$DELIMITER/ /g"`
	columnPrimaryKey=`sed -n '3p' .$tableName`
	index=1
 	for i in ${columnNameInFile[@]}
	do
		echo "$index) $i"
		columnsNameArray[$index]=$i
		let "index++"
	done
	(( index = 1 ))
 	for i in ${columnDatatypeInFile[@]}
	do
		columnsDatatypeArray[$index]=$i
		let "index++"
	done
}

# check if the user inserts duplicated primary key. 
function checkOnPrimaryKey(){
	currentValueOfPrimaryKey=`echo $1 | cut -f$columnPrimaryKey -d$DELIMITER`
	checkOnPrimaryKey=`cut -f$columnPrimaryKey -d$DELIMITER $tableName | grep "$newData" | wc -l`
	if [[ ($checkOnPrimaryKey == 0 || $currentValueOfPrimaryKey == $newData) && ${#newData} > 0 ]]
	then
		replaceStatement+=$newData
		columnUpdated=1
	else
		echo -e "\e[31mDuplicated value for primary key\e[0m" 
	fi
}

# function to over write the old record with the new record with making validation on the inserted datatype of columns
function replaceRecordInTable(){
	echo THE OLD RECORD
	tableView $1 $DELIMITER
	local replaceStatement=""
	typeset -i currentColumn=1
 	for i in ${columnsNameArray[@]}
	do
		if [[ currentColumn -gt 1 ]]
		then 
			replaceStatement+=$DELIMITER
		fi
		columnUpdated=0
		while [[ $columnUpdated == 0 ]]
		do
			read -p "please enter the new $i: " newData
			if [[ ( ${columnsDatatypeArray[currentColumn]} == INT && $newData =~ ^[0-9]+$ ) ||
			      ( ${columnsDatatypeArray[currentColumn]} == DATE && $newData == `date -d $newData '+%Y-%m-%d'` ) ||
			      ( ${columnsDatatypeArray[currentColumn]} == STRING ) ]]
			then
				if [[ $columnPrimaryKey != $currentColumn ]]
				then
					replaceStatement+=$newData
					break
				else
					checkOnPrimaryKey $1
				fi
			else
				echo -e "\e[31mWrong datatype, you shoud insert ${columnsDatatypeArray[currentColumn]}.\e[0m"
			fi
		done
		let "currentColumn++"	
	done
	sed -i "0,/$1/s//$replaceStatement/" $tableName
}

#function to update old records with new records
function updateTable() {
	echo ------------------------------------------------------------------------ 
	checkOnTable
	echo "please select on column to search for: "
	getColumnNamesAndDatatypeInArraysInUpdate
	selectColumnFromTable
	read -p "Please enter the value to search for: " searchValue
	numberOfMatchedRows=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print NR}}' $tableName`
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print $0}}' $tableName`
	typeset -i counter=0
 	for i in ${replaceLocations[@]}
	do
		(( counter++ ))
	done
	if [[ $counter == 0 ]]
	then
		echo -e "\e[31mNo matched record.\e[0m"
	elif [[ $counter == 1 ]]
	then
		replaceRecordInTable $replaceLocations
		echo -e "\e[32mThe table has been updated.\e[0m"
	else
		echo the matched records are $counter records
	 	for j in ${replaceLocations[@]}
		do
			replaceRecordInTable $j
		done
		echo -e "\e[32mThe table has been updated.\e[0m"
	fi	
	echo ------------------------------------------------------------------------ 	
}







