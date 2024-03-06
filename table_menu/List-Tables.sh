#! /bin/bash
echo "Enter the name of the database you want to list its tables: "
read DB_name

if [ -d databases/$DB_name ]; then
    if [ `ls databases/$DB_name -l | wc -l` -gt 1 ]; then
        echo "your tables are: "
        ls databases/$DB_name

    else
        echo "There are no tables to show."
    fi

else
    echo "There is no such database called $DB_name."
fi

./table_menu/manageDB.sh 