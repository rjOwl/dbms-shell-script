#!/bin/bash

. globals.sh

function insertIntoTable(){
    # takes table name and that's it
    # get number of columns
    # get the types
    # check primary key
    echo ----------------------------------------------------------------------------
    read -p "Table name to insert into> " name
    until [ -f $name ] 
    do
    	    echo -e "\e[31mNo such table name in this database.\e[0m"
	    read -p "Table name to insert into> " name
    done
    local length=$(head -n 1 .$name | tr $DELIMITER ' ' | wc -w)
    local columns_names=($(head -n 1 .$name | tr $DELIMITER ' '))
    local columns_types=($(head -n 2 .$name | tail -n 1 | tr $DELIMITER ' '))
    local pkColNum=$(tail -n 1 .$name )
    local new_record=()
    printTableColums=`head -n 1 .$name`
    echo "-----------------$name----------------"
    tableView $printTableColums $DELIMITER
    for (( i=0; $i < $length; i++ ))
    do
        read -p "Input your ${columns_names[$i]}> " cellValue
        if [[ ( ${columns_types[$i]} == INT && $cellValue =~ ^[0-9]+$ )|| ( ${columns_types[$i]} == STRING )|| ( ${columns_types[$i]} == "DATE" && $cellValue ==  $(date -d $cellValue '+%Y-%m-%d') ) ]]
            then 
                if [ $i -eq `expr $pkColNum - 1` ]
                    then
                    if (( `cut -d$DELIMITER -f $pkColNum $name | grep $cellValue | wc -l` > 0 ))
                            then
                                echo "Enter another primary key please."
                                i=$i-1
                                continue
                        else
                            new_record+=($cellValue)
                    fi
                else
                    new_record+=($cellValue)
                fi
            else
                i=$i-1
                continue
        fi
    done
    echo ${new_record[@]}$EOF | tr " " $DELIMITER >> $name
    echo ----------------------------------------------------------------------------
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
    ls -1 .
	echo ----------------------------------------------------------------------------
}

function renameTable(){
    tableName=$1
    new_name=$2
    mv $tableName $new_name
    mv .$tableName .$new_name
    echo -e "\e[32mDONE\e[0m"
    echo ----------------------------------------------------------------------------
}

function dropTable(){
    # takes table
    read -p "Table name to drop> " table_name
    tableExists $table_name
    t=$?
    if [ $t -eq 1 ]
    then
        mv $1 .$1 .trash
	echo -e "\e[32mDONE\e[0m"
    else echo "Table is not found"
    fi
    echo ----------------------------------------------------------------------------
}

