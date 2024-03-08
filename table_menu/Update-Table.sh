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

echo "Enter the new value for $column_name: "
read new_value

# Update the column in the table
awk -v col="$column_name" -v val="$new_value" 'BEGIN{FS=OFS=","} NR==1{$col=val} NR>1{$col=$col} 1' "./databases/$DB_name/$TableName" > temp && mv temp "./databases/$DB_name/$TableName"

if [ $? -eq 0 ]; then
    echo "Column $column_name updated successfully with value $new_value"
else
    echo "Failed to update column $column_name"
    exit 1
fi

# Adding rows to the table
echo "Enter values for the new row (in the same order as columns): "
read -r new_row_values

# Append the new row to the table
echo "$new_row_values" >> "./databases/$DB_name/$TableName"

if [ $? -eq 0 ]; then
    echo "New row added successfully"
else
    echo "Failed to add new row"
fi
