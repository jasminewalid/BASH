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

echo "Your Columns are : "
columns=$(head -n 1 "./databases/$DB_name/$TableName")
echo "$columns"

echo "What do you want to delete?"
echo "1. Rows"
echo "2. Columns"
read -p "Enter your choice: " choice

case $choice in
    1)  echo "Enter the name of the column for condition: "
        read condition_column

        # Checking if the column exists
        if ! grep -q "$condition_column" <<< "$columns"; then
            echo "$condition_column does not exist in $TableName"
            exit 1
        fi

        echo "Enter the value of the column for condition: "
        read condition_value

        # Delete rows based on condition
        awk -v col="$condition_column" -v val="$condition_value" 'BEGIN{FS=OFS=","} NR==1{print} NR>1 && $col!=val{print}' "./databases/$DB_name/$TableName" > temp && mv temp "./databases/$DB_name/$TableName"

        if [ $? -eq 0 ]; then
            echo "Rows deleted successfully where $condition_column is $condition_value"
        else
            echo "Failed to delete rows"
            exit 1
        fi
        ;;
    2)  echo "Enter the name of the column to delete: "
        read column_name

        # Checking if the column exists
        if ! grep -q "$column_name" <<< "$columns"; then
            echo "$column_name does not exist in $TableName"
            exit 1
        fi

        # Delete column
        awk -v col="$column_name" 'BEGIN{FS=OFS=","} {for (i=1; i<=NF; i++) if ($i == col) $i = ""; gsub(/,+/,",")} 1' "./databases/$DB_name/$TableName" > temp && mv temp "./databases/$DB_name/$TableName"

        if [ $? -eq 0 ]; then
            echo "Column $column_name deleted successfully"
        else
            echo "Failed to delete column $column_name"
            exit 1
        fi
        ;;
    *)  echo "Invalid choice"
        exit 1
        ;;
esac