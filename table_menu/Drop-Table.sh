#!/bin/bash

drop_table() 
{
    echo "Please enter Database Name: "
    read DB_name

    if [ -d "./databases/$DB_name" ]; then
        echo "Your Tables are: "
        ls "./databases/$DB_name"

        echo "Please enter the name of the Table you wish to Drop: "
        read Table_name

        # validation if table exists first
        if [[ -f "./databases/$DB_name/$Table_name" ]]; then
            rm "./databases/$DB_name/$Table_name"
            echo "$Table_name has been dropped successfully"
            echo "Now, your current tables are: "
            ls "./databases/$DB_name"
            return 0 

        else
            echo "$Table_name already doesn't exist"
            return 1 
        fi

    else
        echo "$DB_name does not exist"
        return 1 
    fi
}

drop_table

./table_menu/manageDB.sh