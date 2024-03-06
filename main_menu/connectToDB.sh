#!/bin/bash

function connectToDB () 
{
    read -p "Enter the name of the database to connect: " DB_name
    if [ -d "$DB_name" ]; then
        # Call the script to manage the selected database
        ./manageDB.sh "$DB_name"
        
    else
        echo "Database '$DB_name' does not exist."
    fi
}
connectToDB