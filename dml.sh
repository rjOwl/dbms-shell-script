#!/bin/bash

DELIMITER=';;'

function insertIntoTable(){
    # takes table name and that's it
    # get number of columns
    # get the types
    # check primary key
    local name=$1
    local length=$(head -n 1 .$name | tr $DELIMITER ' ' | wc -w)
    local columns_names=($(head -n 1 .$name | tr $DELIMITER ' '))
    local columns_types=($(head -n 2 .$name | tail -n 1 | tr $DELIMITER ' '))
    local pkColNum=$(tail -n 1 .$name )
    # echo $length ${columns_names[1]} ${columns_types[1]} $pkColNum
    local new_record=()
    echo -----------------------------------------
    echo "-----------------$name----------------"
    echo ${columns_names[@]}
    echo -----------------------------------------
    for (( i=0; i<$length; i++ ))
        do
            read -p "Input your ${columns_names[$i]}> " cell

            if [[ ${columns_types[$i]} == INT ]]
            then
                if [[ $cell =~ ^[0-9]+$ ]]
                    then
                        if [ $i -eq `expr $pkColNum - 1` ]
                            then
                                # check_id $name $pkColNum $
                                # res=$?
                                if [ `cut -d $DELIMITER -f $pkColNum $name | grep $cell` ]
                                    then
                                        echo "Enter another primary key please."
                                        i=$i-1
                                        continue
                                else
                                    new_record+=($cell)
                                    echo "NUMBER"
                                fi
                            else
                                new_record+=($cell)
                                echo "NUMBER"
                        fi
                else
                    i=$i-1
                    echo "Not number"
                    continue
                fi
            elif [[ ${columns_types[$i]} == STRING ]]
            then
                if [[ $cell =~ ^[a-zA-Z]+$ ]]
                then
                    if [ $i -eq `expr $pkColNum - 1` ] 
                        then
                            # check_id $name $pkColNum $
                            # res=$?
                            if [ `cut -d $DELIMITER -f $pkColNum $name | grep $cell` ]
                                then
                                    echo "Enter another primary key please."
                                    i=$i-1
                                    continue
                            else
                                new_record+=($cell)
                                echo "String"
                            fi
                        else
                            new_record+=($cell)
                            echo "String"
                    fi
                else
                    i=$i-1
                    echo "Not string"
                    continue
                fi
            elif [[ ${columns_types[$i]} == "DATE" ]]
            then
                if [[ $cell ==  $(date -d $cell '+%Y-%m-%d') ]]
                then
                    if [ $i -eq `expr $pkColNum - 1` ]
                        then
                            # check_id $name $pkColNum $
                            # res=$?
                            if [ `cut -d $DELIMITER -f $pkColNum $name | grep $cell` ]
                                then
                                    echo "Enter another primary key please."
                                    i=$i-1
                                    continue
                            else
                                new_record+=($cell)
                                echo "Date"
                            fi
                        else
                            new_record+=($cell)
                            echo "Date"
                    fi
                else
                    i=$i-1
                    echo "Not date"
                    continue
                fi
            else
                echo "Input a good format please"
            fi
        done
    echo ${new_record[@]}$EOF | tr " " $DELIMITER >> $name
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
}

function renameTable(){
    tableName=$1
    new_name=$2
    mv $tableName $new_name
}

function dropTable(){
    # takes table 
    tableExists $1 
    t=$?
    if [ $t -eq 1 ]
        then 
        mv $1 .trash
    else echo "Table is not found"
    fi
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
