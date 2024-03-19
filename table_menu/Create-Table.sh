#! /bin/bash	
echo "Enter your Database Name : "
read DB_name

if [ -d  ./databases/$DB_name ] 
# validation to check if this Database exists or not       
then
    if [ "$(ls databases/$DB_name -l | wc -l)" -gt 1 ]; then	# Greater than , wc -l  prints the line count
        echo "Your Tables are : $(ls ./databases/$DB_name)"
    else
        echo "Your database is Empty" 
    fi

    while true; do
        echo "Enter your New Table Name:"

        read TableName
        # validation to check if the name is valid
        if [[ ! $TableName =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $TableName == '' ]]; then
            echo "Not a Valid Name for Table"
        # validation to check if the table already exists
        elif [[ -f ./databases/$DB_name/$TableName ]]; then
            echo "$TableName already exists"
        else
            touch ./databases/$DB_name/$TableName # creates it successfully
            break
        fi
    done

    # columns
    echo "Enter the number of columns : "
    read colNum
    while [ $colNum -le 0 ]; do                      # to check the entered number > 0  while 1
        echo "please enter a valid number"
        echo "Enter the number of columns : "
        read colNum
    done                                          

    i=1
    separator=","
    pkey="true"
    metadata=""  # the output data about each column    

    while [ $i -le $colNum ]; do                     # loop to get all data for each column  
        echo "Enter Name of column Number $i : "
        read colName

        if [ -z "$colName" ]; then                  #test for empty column name if 1
            echo "column name can not be empty"
            echo "Enter the column Name : "
            read colName
        fi

        echo "data type of column $colName"
    
        select typ in "int" "string"; do           # to select the constraint of the column
            case $typ in
                int )
                    colType="int"
                    break ;;
                string )
                    colType="string"
                    break ;;
                * )
                    echo "invalid choice. please choose int or string."
            esac
        done 
        
        Pk="notPrimk"
        if [ $pkey == "true" ]; then               # to make this column Primary key or Not                   
            echo "Do you want to make it a primary Key? [y/n] : "
            read choice
            case $choice in
                [Yy] )
                    Pk="Pk"
                    pkey="False"
                    ;;
                [Nn] ) 
                    Pk="notPrimk"
                    ;;
                * )
                    echo "invalid choice. please type Y or N."
            esac
        fi
        metadata+="$colName$colType$Pk$separator"                                   
        ((i=$i+1))                              # to increase i by 1 
        
    done    
    metadata=${metadata%?}                               

    echo "$metadata" >> ./databases/$DB_name/$TableName
    
    if [ $? == 0 ]; then                        # to check the last run by the right way
        echo "Table created successfully!"
    
    else
        echo "There were errors, could not create $TableName"
    fi
    table_menu/manageDB.sh # to go back to the menu again

else
    echo "$DB_name does not exist"
    main_menu/connectToDB.sh # to go back to the menu again

fi