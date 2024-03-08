#!/bin/bash

table_menu() 
{
    echo "+==============================================================+"
    echo "|                      Table Menu                              |"
    echo "|==============================================================|"
    echo "|                   1. Create Table                            |"
    echo "|                   2. List Tables                             |"
    echo "|                   3. Select From Table                       |"
    echo "|                   4. Insert Into Table                       |"
    echo "|                   5. Update Table                            |"
    echo "|                   6. Delete From Table                       |"
    echo "|                   7. Drop Table                              |"
    echo "|                   8. Exit                                    |"
    echo "+==============================================================+"
    echo "Please choose a number : "

    read -r Choice
    case $Choice in
        1) table_menu/Create-Table.sh ;;
        2) table_menu/List-Tables.sh ;;
        3) table_menu/Select-From-Table.sh ;;
        4) table_menu/Insert-Into-Table.sh ;;
        5) table_menu/Update-Table.sh ;;
        6) table_menu/Delete-From-Table.sh ;;
        7) table_menu/Drop-Table.sh ;;
        8) echo "ByeBye!"
           exit ;;

        *) echo "Invalid choice, please choose from the listed items!"
           table_menu ;;
    esac
}

table_menu