DELIMITER=';'

# function to check if the table is exist
function checkOnTable(){
	read -p "please insert table name: " tableName
	until [ -f $tableName ] 
	do
		echo -e "\e[31mNo such table name in this database.\e[0m"
		read -p "please insert table name: " tableName
	done 
}

# make user select column to search about it.
function selectColumnFromTable(){
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







# Disply the Old record values that will be updated.
function tableView(){
	local printLine=`echo $1 | sed "s/$2/ | /g"`
	(( lineLength = ${#printLine} + 4 ))


		typeset -i j=0
		while [ $j -lt $lineLength ] 
		do
			printf "-"
			let "j++"
		done
		echo " "
		echo '| '$printLine' |'
		j=0
		while [ $j -lt $lineLength  ]
		do
			printf "-"
			let "j++"
		done
		echo " "
}
