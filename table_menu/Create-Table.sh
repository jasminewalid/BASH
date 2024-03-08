#!/bin/bash

echo "Enter your Database Name : "
read DB_name

if [ -d  ./databases/$DB_name ]
then
    if [ $(ls -l databases/$DB_name | wc -l) -gt 1 ]; then
        echo "Your Tables are: $(ls ./databases/$DB_name)"
    else
        echo "Your database is Empty"
    fi

    echo "Enter your New Table Name:"
    read TableName

    if [[ ! $TableName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $TableName == '' ]]; then
        echo "Not a Valid Name for Table"
    elif [[ -f ./databases/$DB_name/$TableName ]]; then
        echo "$TableName already exists"
        ./table_menu/manageDB.sh
    else
        touch ./databases/$DB_name/$TableName
    fi

    echo "Enter the number of columns: "
    read colNum

    while [ $colNum -le 0 ]; do
        echo "Please enter a valid number of columns"
        read colNum
    done

    i=1
    separator=","
    pkey="true"
    metadata="$colName""$ColType"$pkey"$separator"

    while [ $i -le $colNum ]; do
        echo "Enter Name of column Number $i : "
        read colName

        if [ -z "$colName" ]; then
            echo "Column name cannot be empty"
            echo "Enter the column Name : "
            read colName
        fi

        echo "Enter data type of column $colName"
    
        select typ in "int" "string"; do
            case $typ in
                int)
                    colType="int"
                    break ;;
                string)
                    colType="string"
                    break ;;
                *)
                    echo "Invalid choice. Please choose int or string." ;;
            esac
        done 
        
        if [ $pkey == "true" ]; then
            echo "Do you want to make it a primary Key? [y/n] : "
            read choice
            case $choice in
                [Yy])
                    pkey="Pk"
                    metadata+="%"$colName"%"$colType"%"$pkey"%"$separator
                    ;;
                [Nn]) 
                    metadata+="%"$colName"%"$colType"%"$separator
                    ;;
                *)
                    echo "Invalid choice. Please type Y or N."
            esac
        else
            metadata+="%"$colName"%"$colType"%"$separator
        fi                                   
        ((i=$i+1))
    done                                   

    echo "$metadata" >> ./databases/$DB_name/$TableName 2>>./.error.log
    
    if [ $? == 0 ]; then 
        echo "Table created successfully!"
    else
        echo "There were errors, could not create $TableName"
    fi

    # Add rows to the table
    echo "Enter the number of rows you want to insert: "
    read rowNum

    for ((i = 1; i <= $rowNum; i++)); do
        echo "Enter data for row $i:"
        read -a rowData

        # Write row data to the table file
        echo "${rowData[@]}" >> ./databases/$DB_name/$TableName
    done

    main_menu/connectToDB.sh # Go back to the menu again

else
    echo "$DB_name does not exist"
    main_menu/connectToDB.sh # Go back to the menu again
fi