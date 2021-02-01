#!/bin/bash

. globals.sh

function insertIntoTable(){
    # takes table name and that's it
    # get number of columns
    # get the types
    # check primary key
    #echo ----------------------------------------------------------------------------
    table_name=`zenity --entry --title="Drop Database" --text="Insert your table name"`
    # read -p "Table name to insert into> " table_name
    # local table_name=$1
    local length=$(head -n 1 .$table_name | tr $DELIMITER ' ' | wc -w)
    local columns_names=($(head -n 1 .$table_name | tr $DELIMITER ' '))
    local columns_types=($(head -n 2 .$table_name | tail -n 1 | tr $DELIMITER ' '))
    local pkColNum=$(tail -n 1 .$table_name )
    # echo $length ${columns_names[1]} ${columns_types[1]} $pkColNum
    local new_record=()
    printTableColums=`head -n 1 .$table_name`
    zen_col=''
    for (( i=0; $i < $length; i++ ))
    do
    lower=(`echo "${columns_names[$i]}" | tr '[:upper:]' '[:lower:]'`)
    if [ ${columns_types[$i]} == "DATE" ]
        then
            zen_col+="--add-calendar=${columns_names[$i]} "
        elif  (( $lower == "password" ))
            then
                zen_col+="--add-password=${columns_names[$i]} "
        else
            zen_col+="--add-entry=${columns_names[$i]} "
        fi
    done

    Zen_command=`zenity --forms --title=$table_name --text="Columns" $zen_col`
    cellValue=(`echo "$Zen_command" | tr '|' ' '`)
    # tableView $printTableColums $DELIMITER

    for (( i=0; $i < $length; i++ ))
    do
        # read -p "Input your ${columns_names[$i]}> " cellValue
        if [[ ( ${columns_types[$i]} == INT && ${cellValue[$i]} =~ ^[0-9]+$ )|| ( ${columns_types[$i]} == STRING )|| ( ${columns_types[$i]} == "DATE" ) ]]
            then
                if [ $i -eq `expr $pkColNum - 1` ]
                    then
                    if (( `cut -d$DELIMITER -f $pkColNum $table_name | grep ${cellValue[$i]} | wc -l` > 0 ))
                            then
                    			val=`zenity --notification --title="Error" --text=" Primary key: ${columns_types[$i]} already exists."`
                                insertIntoTable
                        else
                            new_record+=(${cellValue[$i]})
                    fi
                else
                    new_record+=(${cellValue[$i]})
                fi
            else
                i=$i-1
                continue
        fi
    done
    echo ${new_record[@]}$EOF | tr " " $DELIMITER >> $table_name
    zenity --notification --title="Inserting" --text="Row inserted successfully."
    # echo ----------------------------------------------------------------------------
}

function tableExists(){
    if [ -f $1 ]
    then 
        return 1
    else
        return -1
    fi
}


function listTables(){
	zenity --list \
	--title="List of Databases" \
	--column="Tables Names" \
	`ls -1`
}

function renameTable(){
    tableName=$1
    new_name=$2
    mv $tableName $new_name
    mv .$tableName .$new_name
    zenity --notification --title="Rename Table" --text="Done"
}

function dropTable(){
    table_name=`zenity --entry --title="Drop Table" --text='Insert table name to drop'`
    tableExists $table_name
    t=$?
    if [ $t -eq 1 ]
    then
        mv $table_name .$table_name .trash
	zenity --notification --title="Drop Table" --text="Done."
    else 
	zenity --warning --title="Drop Table" --text="Table is not found"
    fi
}

