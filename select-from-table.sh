#!/bin/bash

# variables section
. globals.sh

typeset -i index=1

# function to put the column names and column datatype in array to display them to the user to select from them
function getColumnNamesAndDatatypeInArrays(){
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

# function to over write the old record with the new record with making validation on the inserted datatype of columns
function showSelectedColumn(){
	tableView $1 $DELIMITER

}

#function to update old records with new records
function selectFromTable() {
	clear
	checkOnTable
	echo "please select on column to search for: "
	getColumnNamesAndDatatypeInArrays
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
}







