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

columns=$(head -n 1 "./databases/$DB_name/$TableName")

echo "Your Columns are : "
echo "$columns"

values=""

# Prompt user to enter values for each column
IFS=',' read -ra colNames <<< "$columns"
for colName in "${colNames[@]}"; do
    echo "Enter value for $colName: "
    read value
    values="$values$value,"
done

# Trim trailing comma
values="${values%,}"

# Append the new row to the table
echo "$values" >> "./databases/$DB_name/$TableName"

echo "Your data has been updated successfully"
main_menu/connectToDB.sh