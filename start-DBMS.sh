#!/bin/bash


select choice in $'Create database\n2)List Database\n3)Connect to Database\n4)Drop Database\n'
do
case $REPLY in
    1) echo "1";;
    2) echo "2" ;;
    3) read -p "DB name> " db_name
        dbExist $db_name
        dbExist=$?
        if [ $dbExist -eq 1 ]
        then
            useDb $db_name
            inUseDbPath=$?
            cd $db_name
            echo -e "[] Connection established"
        else echo -e "\033[31m[X]\e[0m Database dosen't exist!"
        fi
    ;;
    4) read -p "DB name> " db_name
        exist $db_name
        dbExist=$?
        isInUse $db_name
        isInUse=$?
        if [ $isInUse -eq 1 ]
        then
            cd ..
        fi
        if [ $dbExist -eq 1 ]
            then
                useDb $db_name
                dbPath=$?
                isDbEmpty $db_name
                isEmpty=$?
                if [ $isEmpty -eq 1 ]
                then
                    echo "Empty schema;"
                    rm "-d" $dbPath
                    echo "Removed database successfully;"
                else
                    echo "DB not empty. Do you want to remove the database with its tables? [N/y]"
                    read ch
                    if [ $ch = y ]
                        then 
                            rm "-dr" $dbPath
                            echo "Removed"
                    else
                        echo
                    fi
                fi
            else
                echo -e "\033[31m[X]\e[0m No database with this name found."
        fi;;
    *) echo "0";;
    esac
done

