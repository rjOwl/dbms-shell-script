DELIMITER=';'

# function to check if the table is exist
function checkOnTable(){
	tableName=`zenity --entry --title="Check on table" --text="please insert table name."`
	until [ -f $tableName ] 
	do
		zenity --warning --title="Check on table" --width="500" --height="100" --text="No such table name in this database."
		tableName=`zenity --entry --title="Check on table" --text="please insert table name."`
	done 
}

function myCheckOnTable(){
	tableName=`zenity --entry --title="Check on table" --text="please insert table name."`
	until [ -f $tableName ] 
	do
		zenity --warning --title="Check on table" --width="500" --height="100" --text="No such table name in this database."
		# tableName=`zenity --entry --title="Check on table" --text="please insert table name."`
		myCheckOnTable
	done 
}

# make user select column to search about it.
function selectColumnFromTable(){
	typeset -i index=1
	columsNameArray=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
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

