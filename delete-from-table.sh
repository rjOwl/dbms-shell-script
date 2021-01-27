#!/bin/bash

#variables section
DELIMITER=";;"

#function to check if the table is exist
function checkOnTable(){
	read -p "please insert table name: " tableName
	until [ -f $tableName ] 
	do
		echo -e "\e[31mNo such table name in this database.\e[0m"
		read -p "please insert table name: " tableName
	done 
}

#function to get the column that will be used to delete the record
function selectColumnFromTable(){
	typeset -i index=1
	echo "please select on column to search for: "
	#loop to show columns name to the user
 	for i in ${columsNameArray[@]}
	do
		echo "$index) $i"
		columnsName[$index]=$i
		let "index++"
	done
	while true
	do
		read -p "The column number is: " searchColumn
		#make sure the input didn't start with 0 to avoid octan number misunderstanding
		while [[ $searchColumn =~ 0[0-9]* ]]
		do
			searchColumn=${10#searchColumn}
		done
		#check if the user select valid column
		if [[ $searchColumn > 0 && $searchColumn < $index ]]
		then
			break
		else
			echo -e "\e[31mWrong choice.\e[0m"
		fi
	done
}

#function to delete record from the table.
function deleteFromTable() {
	clear
	checkOnTable
	columsNameArray=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	selectColumnFromTable
	read -p "Please enter the value to search for: " searchValue
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print NR," "}}' $tableName`
	typeset -i index=0
	#check if any record matched.
	if [[ ${#replaceLocations} == 0 ]]
	then
		echo No matched record.
	else
		#loop to delete all records that matched with the user input.
		for i in $replaceLocations
		do
			(( deletedLine = $i - $index ))	
			sed -i "${deletedLine}d" $tableName
			echo the record has been deleted.
			let "index++"
		done 
	fi
}




