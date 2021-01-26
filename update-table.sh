#!/bin/bash

#interface with tables.
function updateTable() {
	clear
	read -p "please insert table name: " tableName
	until [ -f $tableName ] 
	do
		echo -e "\e[31mNo such table name in this database.\e[0m"
		read -p "please insert table name: " tableName
	done 
	dummyName=`sed -n '1p' .$tableName | sed 's/;;/ /g'`
	dummyDatatype=`sed -n '2p' .$tableName | sed 's/;;/ /g'`
	columnPrimaryKey=`sed -n '3p' .$tableName`
	echo $columnsName
	typeset -i index=1
	echo "please select on column to search for: "
 	for i in ${dummyName[@]}
	do
		echo "$index) $i"
		columnsName[$index]=$i
		let "index++"
	done
	(( index = 1 ))
 	for i in ${dummyDatatype[@]}
	do
		columnsDatatype[$index]=$i
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
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue 'BEGIN{FS=";;"} { if($searchColumn == searchValue){ print $0}}' $tableName`
echo $replaceLocations
	replaceStatement=""
	typeset -i k=1
 	for i in ${columnsName[@]}
	do
		if [[ k -gt 1 ]]
		then 
			replaceStatement+=";;"
		fi
		while true
		do
			read -p "please enter the new $i: " dummy
			if [[ ${columnsDatatype[k]} == INT && $dummy =~ ^[0-9]+$ ]]
			then
				if [[ $columnPrimaryKey != $k ]]
				then
					replaceStatement+=$dummy
					break
				else
					currentValueOfPrimaryKey=`echo $replaceLocations | cut -f$columnPrimaryKey -d";"`
					checkOnPrimaryKey=`cut -f$columnPrimaryKey -d";" $tableName | grep "$dummy" | wc -l`
					if [[ ($checkOnPrimaryKey == 0 || $currentValueOfPrimaryKey == $dummy) && ${#dummy} > 0 ]]
					then
						replaceStatement+=$dummy
						break
					else
						echo -e "\e[31mDuplicated value for primary key\e[0m" 
					fi
				fi
			#elif [[ ${columnsDatatype[k]} == DATE && $dummy =~ ^[0-3][0-9]-[0-3][0-9]-[1-2][0-9][0-9][0-9]$ ]]
			elif [[ ${columnsDatatype[k]} == DATE && `date -d $dummy '+%Y-%m-%d'`  ]]
			then
				if [[ $columnPrimaryKey != $k ]]
				then
					replaceStatement+=$dummy
					break
				else
					currentValueOfPrimaryKey=`echo $replaceLocations | cut -f$columnPrimaryKey -d";"`
					checkOnPrimaryKey=`cut -f$columnPrimaryKey -d";" $tableName | grep "$dummy" | wc -l`
					if [[ ($checkOnPrimaryKey == 0 || $currentValueOfPrimaryKey == $dummy) && ${#dummy} > 0 ]]
					then
						replaceStatement+=$dummy
						break
					else
						echo -e "\e[31mDuplicated value for primary key\e[0m" 
					fi
				fi
			elif [[ ${columnsDatatype[k]} == STRING ]]
			then
				if [[ $columnPrimaryKey != $k ]]
				then
					replaceStatement+=$dummy
					break
				else
					currentValueOfPrimaryKey=`echo $replaceLocations | cut -f$columnPrimaryKey -d";"`
					checkOnPrimaryKey=`cut -f$columnPrimaryKey -d";" $tableName | grep "$dummy" | wc -l`
					if [[ ($checkOnPrimaryKey == 0 || $currentValueOfPrimaryKey == $dummy) && ${#dummy} > 0 ]]
					then
						replaceStatement+=$dummy
						break
					else
						echo -e "\e[31mDuplicated value for primary key\e[0m" 
					fi
				fi
			else
				echo -e "\e[31mWrong datatype, you shoud insert ${columnsDatatype[k]}.\e[0m"
			fi
		done
		let "k++"	
	done
echo $replaceStatement
sed -i "s/$replaceLocations/$replaceStatement/g" $tableName
}

updateTable

