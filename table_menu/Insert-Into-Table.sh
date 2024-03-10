#! /bin/bash

echo "Enter your Database Name : "
read DB_name

echo "Available tables are : $(ls ./databases/$DB_name)"

echo "Which table do you want to insert into : "
read TableName

row=""

# Get the number of columns in the table
columnCount=$(awk -F, 'NR==1 {print NF}' ./databases/$DB_name/$TableName)

for ((i=1; i<=$columnCount; i++)); do
    columnNumber=$i
    echo -n "$i - "

    # Get column type and name
    columnType=$(grep "%," ./databases/$DB_name/$TableName | cut -d "," -f$columnNumber | cut -d% -f3)
    colName=$(grep "%," ./databases/$DB_name/$TableName | cut -d "," -f$columnNumber | cut -d% -f2)

    echo "Column Name: $colName, Type: $columnType"

    # Prompt user for value of the column
    echo -n "Enter the value of column number $columnNumber : "
    read val

    # Validate input based on column data type
    if [ "$columnType" == "string" ]; then
        # Validation for string datatype
        while [[ -z $val || $val =~ [\,\;\:\-\/\\] ]]; do
            echo "Invalid input! Empty value or special characters are not allowed."
            echo -n "Enter the value of column number $columnNumber : "
            read val
        done
    elif [ "$columnType" == "int" ]; then
        # Validation for integer datatype
        while ! [[ "$val" =~ ^[0-9]+$ ]]; do
            echo "Invalid input! Datatype of column number $columnNumber is integer."
            echo -n "Enter the value of column number $columnNumber : "
            read val
        done
    fi

    # Check if the column is a primary key
    testPk=$(grep "%," ./databases/$DB_name/$TableName | cut -d "," -f$columnNumber | grep %Pk% | cut -d% -f4)

    # Check if the value already exists in the primary key column
    if [ "$testPk" == "Pk" ]; then
        if grep -qw "$val" ./databases/$DB_name/$TableName; then
            echo "This value already exists"
            main_menu/connectToDB.sh
        else
            if [ -z "$row" ]; then
                row="$val"
            else
                row="$row,$val"
            fi
        fi
    fi
done

echo "$row" >> ./databases/$DB_name/$TableName 2>/dev/null
echo "Your data has been updated successfully"
main_menu/connectToDB.sh