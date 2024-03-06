#!/bin/bash

function listDB () 
{
    local databases=$(find . -maxdepth 1 -type d -printf '%f\n')

    if [ -z $databases ]; then
        echo "Currently, there are no any databases in the system." 
        #validation for whether there are any databases or not

    else
        echo "List of Databases:"
        echo "$databses"
        #ls -d */ | cut -f1 -d'/'
    fi
}
listDB