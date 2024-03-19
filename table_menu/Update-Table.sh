#!/bin/bash

echo "Enter your Database Name : "
read DB_name

echo "Enter your Table Name : "
read TableName

if [ ! -d "./databases/$DB_name" ]; then
    echo "$DB_name does not exist"
    exit 1
fi

if [ ! -f "./databases/$DB_name/$TableName" ]; then
    echo "$TableName does not exist in $DB_name"
    exit 1
fi

echo "Your Columns are : "
columns=$(head -n 1 "./databases/$DB_name/$TableName")
echo "$columns"

echo "Enter the name of the column you want to update: "
read column_name

# Checking if the column exists
if ! grep -q "$column_name" <<< "$columns"; then
    echo "$column_name does not exist in $TableName"
    exit 1
fi


 echo "Enter the new value: "
 read new_value

awk -v col="$column_name" -v val="$new_value" 'BEGIN{FS=OFS=","} {if (NR > 1) $col=val} 1' "./databases/$DB_name/$TableName" > temp && mv temp "./databases/$DB_name/$TableName"

if [ $? -eq 0 ]; then
  echo "Column $column_name updated successfully with value $new_value"
else
  echo "Failed to update column $column_name"
  exit 1
fi