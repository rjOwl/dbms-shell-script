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
