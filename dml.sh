#!/bin/bash

DELIMITER=' ;;; '

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
}

function renameTable(){
    tableName=$1
    new_name=$2
    mv $tableName $new_name
}

function rollbackTable(){

}

function dropTable(){
    # takes table 
    mv $1 .trash
}

function selectFrom(){
    # default all
    local table_name=$1
    local columns=$2
    if [[ $columns = '*' ]]
        then
            echo "************************************3aaaaaaaaaa"
            cat $table_name
    else
        awk -F\'$DELIMITER\' "{if($1 == $columns) print $0}" $table_name
    fi
}

function insertInto(){
# takes table columns
    local table_name=$1
    local columns=$@
    columns=("${columns[@]/$table_name}")
    echo $columns | sed 's/ / ;;; /g'>> $table_name
}

# function updateRecord(){
# # takes table 
# }
# function deleteRecord(){
# # takes table
# }

function check_id(){
    local table_name=$1
    local id=$2
    if [ cut -f 1 -d $DELIMITER $table_name | grep $id  ]
        return 1 #found
    return -1 # id not found
}



