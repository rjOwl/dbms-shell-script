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
		echo "$index) $i"
		columnsNameArray[$index]=$i
		let "index++"
	done
}

function getSelectedColumnsFromUser(){
	while true
	do
		tableView `sed -n "1p" .$tableName` $DELIMITER
		echo "please select columns from the table separated by ',' or space from above columns:" 
		read selectedColumns
		selectedFields=""
		local rightColumnName=0
		columnNameInSelect=`echo $selectedColumns | sed "s/,/ /g"`


		outsideLoop=1
	 	for i in ${columnNameInSelect[@]}
		do
			insideLoop=1
			rightColumnName=0
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
					rightColumnName=1
					break
				fi
				let "insideLoop++"
			done
			if [[ $rightColumnName == 0 ]]
			then
				echo -e "\e[31mNo such column with '$i' name.\e[0m"
				break
			fi
			let "outsideLoop++"
			
		done
		if [[ $rightColumnName == 1 ]]
		then
			break			
		fi
	done
}

#function to update old records with new records
function selectFromTable() {
	echo ----------------------------------------------------------------------------
	checkOnTable
	echo "please select on column to search for: "
	getColumnNamesAndDatatypeInArrays
	selectColumnFromTable
	read -p "Please enter the value to search for: " searchValue
	getSelectedColumnsFromUser
	selectLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER -v Fields=$selectedFields 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){StringLine = " "; arrayLength = split(Fields , arr , delimiter); for(i = 1; i <= arrayLength; i++){if(i != arrayLength){StringLine = StringLine$arr[i]delimiter}else{StringLine = StringLine$arr[i]}}print StringLine}}' $tableName`
	typeset -i counter=0
 	for i in ${selectLocations[@]}
	do
		(( counter++ ))
	done
	if [[ $counter == 0 ]]
	then
		echo -e "\e[31mNo matched record.\e[0m"
	elif [[ $counter == 1 ]]
	then
		tableView $selectLocations $DELIMITER
		echo -e "\e[32mThe table has been updated.\e[0m"
	else
		echo the matched records are $counter records
	 	for j in ${selectLocations[@]}
		do
			tableView $j $DELIMITER
		done
		echo -e "\e[32mThe table has been updated.\e[0m"
	fi	
	echo ----------------------------------------------------------------------------	
}

	








