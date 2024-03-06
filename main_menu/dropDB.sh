#!/bin/bash

function dropDB ()
{
    read -p "Enter the name of the database to drop: " DB_name
    if [ -d "$DB_name" ]; then
        rm -r "$DB_name"

        echo "Database '$DB_name' dropped successfully."

    else
        echo "Database '$DB_name' does not exist."
        #validation for whether the chosen database exists or not

    fi
}
dropDB