#!/bin/bash

# variables section
. globals.sh

typeset -i index=1

# function to put the column names and column datatype in array to display them to the user to select from them
function getColumnNamesAndDatatypeInArraysToUpdate(){
	columnNameInFile=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	columnDatatypeInFile=`sed -n '2p' .$tableName | sed "s/$DELIMITER/ /g"`
	columnPrimaryKey=`sed -n '3p' .$tableName`
	radio_string=''
	index=1
	echo ${columnNameInFile[@]}
 	for i in ${columnNameInFile[@]}
	do
		columnsNameArray[$index]=$i
		columnsDatatypeArray[$index]=${columnDatatypeInFile[@]}
		radio_string+=" $index $i "
		let "index++"
	done
	echo $radio_string
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
		check=`zenity --warning --title="Not matched" --width="500" --height="100"  --text="Duplicated value for primary key"`
	fi
}

# function to over write the old record with the new record with making validation on the inserted datatype of columns
function replaceRecordInTable(){
	tableView $1 $DELIMITER
	local replaceStatement=""
	typeset -i currentColumn=1
	local length=$(head -n 1 .$tableName | tr $DELIMITER ' ' | wc -w)
    zen_col=''
	cols=($columnNameInFile)
	cols_types=($columnDatatypeInFile)

	for (( i=0; $i < $length; i++ ))
    do
		lower=(`echo "${cols[$i]}" | tr '[:upper:]' '[:lower:]'`)
		if [ ${cols_types[$i]} == "DATE" ]
		then
			zen_col+="--add-calendar=${cols[$i]} "
		elif  [[ $lower == "password" ]]
			then
				zen_col+="--add-password=${cols[$i]} "
		else
			zen_col+="--add-entry=${cols[$i]} "
		fi
    done
    Zen_command=`zenity --forms --title=$tableName --text="Columns" $zen_col`

    cellValue=(`echo "$Zen_command" | tr '|' ' '`)

	local err=0
	local index=0;
 	for i in ${columnsNameArray[@]}
		do
			if [[ currentColumn -gt 1 ]]
			then
				replaceStatement+=$DELIMITER
			fi
			columnUpdated=0
			while [[ $columnUpdated == 0 ]]
			do
				newData=${cellValue[$index]}
				if [[ ( ${cols_types[$index]} == INT && $newData =~ ^[0-9]+$ ) ||
					( ${cols_types[$index]} == DATE ) ||
					( ${cols_types[$index]} == STRING ) ]]
				then
					if [[ $columnPrimaryKey != $currentColumn ]]
					then
						replaceStatement+=$newData
						index=$index+1
						# echo ${columnsNameArray[@]}
						break
					else
						checkOnPrimaryKey $1
						index=$index+1
						# err=1
						# break
					fi
				else
					check=`zenity --warning --title="Not matched" --width="500" --height="100"  --text="Wrong datatype, you shoud insert ${cols_types[$index]}."`
					err=1
					break
				fi
			done
			if [ $err -eq 1 ]
				then
				break
			fi
			let "currentColumn++"
		done
	sed -i "0,/$1/s//$replaceStatement/" $tableName
}

#function to update old records with new records
function updateTable() {
	clear
	checkOnTable
	# echo "please select on column to search for: "
	getColumnNamesAndDatatypeInArraysToUpdate

	colomnChoice=$(zenity  --list  --text "Table Columns" --radiolist  --column "Pick" --column "options" $radio_string);
	searchColumn=0
	for i in "${!columnsNameArray[@]}"; do
		if [[ "${columnsNameArray[$i]}" = "${colomnChoice}" ]]; then
			searchColumn=${i};
		fi
	done

    searchValue=`zenity --entry --title="Update table" --text="Select value for your $colomnChoice"`
	numberOfMatchedRows=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print NR}}' $tableName`
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print $0}}' $tableName`
	echo "TEST"
	echo $replaceLocations

	typeset -i counter=0
 	for i in ${replaceLocations[@]}
	do
		(( counter++ ))
	done

	if [[ $counter == 0 ]]
	then
		check=`zenity --warning --title="Not matched" --width="500" --height="100"  --text="Didn't find records"`
	elif [[ $counter == 1 ]]
	then
		replaceRecordInTable $replaceLocations
		check=`zenity --warning --title="Successful" --width="500" --height="100"  --text="The table has been updated"`
	else
		echo the matched records are $counter records
	 	for j in ${replaceLocations[@]}
		do
			replaceRecordInTable $j
		done
		check=`zenity --warning --title="Successful" --width="500" --height="100"  --text="The table has been updated"`
	fi		
}








