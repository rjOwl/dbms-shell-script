#!/bin/bash

#variables section
. globals.sh

#function to get the column that will be used to delete the record
function delSelectColumnFromTable(){
	typeset -i index=1
	columsNameArray=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	#echo "please select on column to search for: "
	searchColumn=`zenity --list --title="Column Names" --height="300" --column=Menu $columsNameArray --text="please select on column to search for"`
	#loop to show columns name to the user
 	for i in ${columsNameArray[@]}
	do
		if [[ $i == $searchColumn ]]
		then
			searchColumn=$index
			break
		fi
		let "index++"
	done
}

#function to delete record from the table.
function deleteFromTable() {
	checkOnTable
	selectColumnFromTable
	searchValue=`zenity --entry --title="get value to search for" --text="Please enter the value to search for."`
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print NR," "}}' $tableName`
	typeset -i index=0
	#check if any record matched.
	if [[ ${#replaceLocations} == 0 ]]
	then
		zenity --warning --title="Delete from table" --width="500" --height="100"  --text="No matched record."
	else
		#loop to delete all records that matched with the user input.
		for i in $replaceLocations
		do
			(( deletedLine = $i - $index ))	
			sed -i "${deletedLine}d" $tableName
			let "index++"
		done 
		zenity --notification --title="Delete from table" --text="delete record(s) has finished successfully."
	fi
}




