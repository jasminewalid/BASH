#!/bin/bash

function createDB () 
{
    read -p "Enter a name for the new database: " DB_name

    if [ -d "$DB_name" ]; then
        echo "Database '$DB_name' already exists." 
        #validation for whether the database already exists


    else
        mkdir "$DB_name"
        echo "Database '$DB_name' created successfully."
    fi
}
createDB