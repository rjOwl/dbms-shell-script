#!/bin/bash
. database_logic.sh
clear
if [ ! -d Database-schema ]
then
	mkdir Database-schema
fi

cd Database-schema
echo "                            Welcome to OurSQL"
echo ------------------------------------------------------------------------


PS3="please enter your choice: "
select userChoice in $'Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'
do case $REPLY in
    1) createNewDatabase ;;
    2) listDatabases ;;
    3) connectDb ;;
    4) dropDb ;;
    5) break ;;
    *) echo -e "\e[31mWrong choice! please choose from the above choices.\e[0m"
        echo ------------------------------------------------------------------------ ;;
	esac
	echo $'1) Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'
done





