#!/bin/bash

#interface with tables.
function deleteFromTable() {
	clear
	read -p "please insert table name: " tableName
	until [ -f $tableName ] 
	do
		echo -e "\e[31mNo such table name in this database.\e[0m"
		read -p "please insert table name: " tableName
	done 
	dummyName=`sed -n '1p' .$tableName | sed 's/;;/ /g'`
	echo $columnsName
	typeset -i index=1
	echo "please select on column to search for: "
 	for i in ${dummyName[@]}
	do
		echo "$index) $i"
		columnsName[$index]=$i
		let "index++"
	done
	while true
	do
		read -p "The column number is: " searchColumn
		if [[ $searchColumn > 0 && $searchColumn < $index ]]
		then
			break
		else
			echo -e "\e[31mWrong choice.\e[0m"
		fi
	done
	read -p "Please enter the value to search for: " searchValue
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue 'BEGIN{FS=";;"} { if($searchColumn == searchValue){ print NR," "}}' $tableName`
	typeset -i index=0
	for i in $replaceLocations
	do
		echo $i	
		(( deletedLine = $i - $index ))	
		sed -i "${deletedLine}d" $tableName
		let "index++"
	done 

}

deleteFromTable

