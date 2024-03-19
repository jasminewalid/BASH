#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to insert rows into a table
insert_row() {
    local DB_name="$1"
    local TableName="$2"
    local row=""

    # Get the number of columns in the table
    local columnCount=$(awk -F, 'NR==1 {print NF}' "./databases/$DB_name/$TableName")

    for ((i=1; i<=$columnCount; i++)); do
        local columnNumber=$i

        # Get column type and name
        local columnType=$(grep "%," "./databases/$DB_name/$TableName" | cut -d "," -f$columnNumber | cut -d% -f3)
        local colName=$(grep "%," "./databases/$DB_name/$TableName" | cut -d "," -f$columnNumber | cut -d% -f2)

        echo -n "Enter the value of column '$colName' (Type: $columnType) : "
        read val

        # Validate input based on column data type
        if [ "$columnType" == "string" ]; then
            # Validation for string datatype
            while [[ -z $val || $val =~ [\,\;\:\-\/\\] ]]; do
                echo "Invalid input! Empty value or special characters are not allowed."
                echo -n "Enter the value of column '$colName' (Type: $columnType) : "
                read val
            done
        elif [ "$columnType" == "int" ]; then
            # Validation for integer datatype
            while ! [[ "$val" =~ ^[0-9]+$ ]]; do
                echo "Invalid input! Datatype of column '$colName' is integer."
                echo -n "Enter the value of column '$colName' (Type: $columnType) : "
                read val
            done
        fi

        # Append value to the row
        if [ -z "$row" ]; then
            row="$val"
        else
            row="$row,$val"
        fi
    done

    # Append row to the table
    echo "$row" >> "./databases/$DB_name/$TableName" || handle_error "Failed to update data in the table '$TableName'"
    echo "Your data has been updated successfully"
}

# Main function
main() {
    echo "Enter your Database Name : "
    read DB_name

    # Check if the database exists
    if [ ! -d "./databases/$DB_name" ]; then
        handle_error "Database '$DB_name' does not exist"
    fi

    echo "Available tables are : $(ls ./databases/$DB_name)"
    echo "Which table do you want to insert into : "
    read TableName

    # Check if the table exists
    if [ ! -f "./databases/$DB_name/$TableName" ]; then
        handle_error "Table '$TableName' does not exist in the database '$DB_name'"
    fi

    # Insert row into the table
    insert_row "$DB_name" "$TableName"
}

# Execute the main function
main

echo "Your data has been updated successfully"
main_menu/connectToDB.sh