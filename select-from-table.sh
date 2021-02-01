#!/bin/bash

# variables section
. globals.sh

typeset -i index=1

# function to put the column names and column datatype in array to display them to the user to select from them
function getColumnNamesAndDatatypeInArrays(){
	columnNameInFile=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	index=1
 	for i in ${columnNameInFile[@]}
	do
		columnsNameArray[$index]=$i
		let "index++"
	done
}

function getSelectedColumnsFromUser(){

	ColumnInCheckList=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ TRUE /g"`
	selectedColumns=`zenity  --list  --text "please select columns from the table to show data"  --checklist  --column "Pick" --column "options" TRUE  $ColumnInCheckList --separator=" "`
	selectedFields=""

	outsideLoop=1
 	for i in ${selectedColumns[@]}
	do
		insideLoop=1
		for j in ${columnNameInFile[@]}
		do
			if [ $i = $j ]
			then
				if [[ ${#selectedFields} == 0 ]]
				then
					selectedFields+=$insideLoop
				else
					selectedFields+=$DELIMITER$insideLoop
				fi
				break
			fi
			let "insideLoop++"
		done
		let "outsideLoop++"
		
	done
	
}

#function to update old records with new records
function selectFromTable() {
	checkOnTable
	selectColumnFromTable
	searchValue=`zenity --entry --title="get value to search for" --text="Please enter the value to search for."`
	getColumnNamesAndDatatypeInArrays
	getSelectedColumnsFromUser
	selectLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER -v Fields=$selectedFields 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){StringLine = " "; arrayLength = split(Fields , arr , delimiter); for(i = 1; i <= arrayLength; i++){if(i != arrayLength){StringLine = StringLine$arr[i]delimiter}else{StringLine = StringLine$arr[i]}}print StringLine}}' $tableName`
	typeset -i counter=0
 	for i in ${selectLocations[@]}
	do
		(( counter++ ))
	done
	if [[ $counter == 0 ]]
	then
		zenity --warning --title="Table Creation" --width="500" --height="100"  --text="No matched record."
	else
		selectedColumns=`echo $selectedColumns | sed "s/ / --column=/g"`
		selectLocations=`echo $selectLocations | sed "s/$DELIMITER/ /g"`
		zenity  --list  --text "Selected Data" --width="500" --height="500" --column=$selectedColumns $selectLocations
	fi
}
