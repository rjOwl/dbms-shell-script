#!/bin/bash

#interface with tables.
function createTable() {
	clear
	read -p "please insert table name: " tableName
	while [ -f $tableName ] 
	do
		echo -e "\e[31mThe table name already exist, please insert another name.\e[0m"
		read -p "please insert table name: " tableName
	done 
	typeset -i endCreation=0
	typeset -i numberOfcolumn=0
	ahmed="Ahmed"
	columnNames=""
	columnDatatype=""
	typeset -i columnPrimaryKey=0
	typeset -i printLine=0
	while [ $endCreation -eq 0 ]
	do

		echo ----------------------------------------------------------------------------
		echo "1) Add new column."
		echo "2) Create table with at least one column."
		echo "3) Exit without save."
		read -p "please insert your choice: " userChoice
		if [[ $userChoice == 2 ]]
		then
			if [ $numberOfcolumn -eq 0 ]
			then
				echo -e "\e[31mNo column in the table, so this table will not be 					created.\e[0m"
				read -p "Are you sure that you want to cancel the table creation 					process [Y/n]: " SureChoice
				if [ $SureChoice != N -o $SureChoice != n ]
				then 
					break 
					echo "----------------------------------------------------------------------------"
				else
					continue			
				fi
			else
				touch .$tableName
				touch $tableName
				echo $columnNames >> .$tableName
				echo $columnDatatype >> .$tableName
				echo $columnPrimaryKey >> .$tableName
				echo "----------------------------------------------------------------------------"
				break
			fi
		elif [[ $userChoice == 1 ]]
		then
			if [[ $numberOfcolumn != 0 ]]
			then
				columnNames+="||"
				columnDatatype+="||"
				typeset -i j=0
				while [ $j -lt $printLine ] 
				do
					printf "-"
					let "j++"
				done
				echo " "
				for i in ${arrayOfColumnName[*]}
				do
					printf "  $i  |"
				done
				echo " "
				j=0
				while [ $j -lt $printLine ]
				do
					printf "-"
					let "j++"
				done
				echo " "
			fi

			read -p "please insert new column name: " newColumnName
			columnNames+=$newColumnName
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
			(( printLine = $printLine + 5 + ${#newColumnName} + ${#Type} ))
			arrayOfColumnName[${numberOfcolumn}]="$newColumnName$Type"
			let "numberOfcolumn++"
			if [[ $columnPrimaryKey == 0 ]]
			then
				read -p "Do you want this key to be your primary key [Y/n]: " 					newColumnPrimaryKey
				if [ $newColumnPrimaryKey != N -o $newColumnPrimaryKey != n ]
				then 
					(( columnPrimaryKey = numberOfcolumn ))			
				fi
			fi
		elif [[ $userChoice == 3 ]]
		then
			break
			echo "----------------------------------------------------------------------------"	
		else
			echo -e "\e[31mWrong choice.\e[0m"
		fi		 
	done
}

