#!/bin/bash

echo "Enter your Database Name: "
read DB_name

echo "Enter your Table Name: "
read TableName

if [ ! -d "./databases/$DB_name" ]; then
    echo "$DB_name does not exist"
    exit 1
fi

if [ ! -f "./databases/$DB_name/$TableName" ]; then
    echo "$TableName does not exist in $DB_name"
    exit 1
fi

cat "./databases/$DB_name/$TableName"
