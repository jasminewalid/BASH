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

echo "Enter the columns you want to select: "
read select_columns

# Check if the entered columns are valid
if [[ "$select_columns" != "*" ]]; then
    for col in $(echo $select_columns | tr ',' ' '); do
        if ! grep -qw "$col" <<< "$columns"; then
            echo "$col is not a valid column name"
            exit 1
        fi
    done
fi

#echo "Enter the condition column name (leave empty if no condition needed): "
#read condition_column

# Check if the condition column is valid
#if [[ -n "$condition_column" ]] && ! grep -qw "$condition_column" <<< "$columns"; then
#    echo "$condition_column is not a valid column name"
#    exit 1
#fi

#echo "Enter the condition value (leave empty if no condition needed): "
#read condition_value

# Retrieve data based on the condition (if provided)
#if [[ -n "$condition_column" ]]; then
#    awk -v col="$condition_column" -v val="$condition_value" -v select="$select_columns" 'BEGIN{FS=OFS=","} NR==1{split(select, sel, ","); for (i=1; i<=NF; i++) if ($i ~ col) index_sel[i]; for (i in sel) if (index_sel[i]) {if (header) header = header "," $i; else header = $i}; print header} NR>1 && $col==val{split(select, sel, ","); for (i in sel) {if (i > 1) printf ","; printf $sel[i]}; printf "\n"}' "./databases/$DB_name/$TableName"
#else
#    awk -v select="$select_columns" 'BEGIN{FS=OFS=","} NR==1{split(select, sel, ","); for (i=1; i<=NF; i++) index_sel[i]; for (i in sel) if (index_sel[i]) {if (header) header = header "," $i; else header = $i}; print header} NR>1{split(select, sel, ","); for (i in sel) {if (i > 1) printf ","; printf $sel[i]}; printf "\n"}' "./databases/$DB_name/$TableName"
#fi