#!/bin/bash

function listDB () 
{
    local databases=$(find databases -maxdepth 1 -mindepth 1 -type d -printf '%f\n')

    if [ -z "$databases" ]; then
        echo "Currently, there are no databases in the system." 
        # Validation for whether there are any databases or not

    else
        echo "List of Databases:"
        echo "$databases"
        #ls -d */ | cut -f1 -d'/'
    fi
}

listDB
./main.sh