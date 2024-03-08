#! /bin/bash	
echo "Enter your Database Name : "
read DB_name

if [ -d  ./databases/$DB_name ] 
# validation to check if this Database exists or not       
then
    if [ `ls databases/$DB_name -l | wc -l`  -gt 1 ];	# Greater than , wc -l  prints the line count
    then 
        echo "Your Tables are : "`ls ./databases/$DB_name`
    else
        echo "Your database is Empty" 
    fi
    echo "Enter your New Table Name:"

    read TableName
    # validation to check if the name is valid
    if [[ ! $TableName =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $TableName == '' ]]
    then
        echo "Not a Valid Name for Table"
    
    # alidation to check if the table alreadyy existss
    elif [[ -f ./databases/$DB_name/$TableName ]]
    then
        echo "$TableName already exists"
        ./table_menu/manageDB.sh    

    else
        touch ./databases/$DB_name/$TableName # creates it successfully
    fi

    # columns
    echo "Enter the number of columns : "
    read colNum
    while [ $colNum -le 0 ]                       # to check the entered number > 0  while 1
    do
        echo "please enter a valid number"
        echo "Enter the number of columns : "
        read colNum
    done                                          

    i=1
    separator=","
    pkey="true"
    metadata="$colName""$ColType"$pkey"$separator"  # the output data about each column    

    while [ $i -le $colNum ]                     # loop to get all data for each column  
    do
        echo "Enter Name of column Number $i : "
        read colName

        if [ -z "$colName" ]                     #test for empty column name if 1
        then
            echo "column name can not be empty";
            echo "Enter the column Name : ";
            read colName;
        fi

        echo "data type of column $colName"
    
        select typ in "int" "string"           # to select the constraint of the column
        do
            case $typ in
                int )
                    colType="int"
                    break ;;
                string )
                    colType="string"
                    break ;;
                * )
                    echo "invalid choice. please choose int or string."   ;;
            esac
        done 
        
        if [ $pkey == "true" ]                   # to make this column Primary key or Not                   
        then
            echo "Do you want to make it a primary Key? [y/n] : "
            read choice
            case $choice in
                [Yy] )
                    pkey="Pk"
                    metadata+="%"$colName"%"$colType"%"$pkey"%"$separator
                    ;;
                [Nn] ) 
                    metadata+="%"$colName"%"$colType"%"$separator
                    ;;
                * )
                    echo "invalid choice. please type Y or N."
            esac
        else
            metadata+="%"$colName"%"$colType"%"$separator
        fi                                   
        ((i=$i+1))                              # to increase i by 1 
    done                                   

    echo $metadata  >> ./databases/$DB_name/$TableName 2>>./.error.log
    
    if [ $? == 0 ]                        # to check the last run by the right way
    then 
        echo "Table created successfuly!"
    else
        echo "there were errors, could not create $TableName"
    fi
    main_menu/connectToDB.sh # to go back to the menu again

else
    echo "$DB_name does not exist"
    main_menu/connectToDB.sh # to go back to the menu again

fi