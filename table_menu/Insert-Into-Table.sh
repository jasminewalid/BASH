#! /bin/bash

echo "Enter your Database Name : "
read DB_name

echo "Avilable tables are : "`ls ./databases/$DB_name`

echo "Which table you want to insert into : "
read TableName

row="";
coloumnsCount=`awk -F, 'NR==1 {print NF}' ./databases/$DB_name/$TableName`

for(( i=1;i<$coloumnsCount;i++ ))
do
	columnNumber=$(echo $i|cut -d ',' -f$i) ;
	echo -n $i "- "
	
	columnType=`grep "%," ./databases/$DB_name/$TableName | cut -d "," -f$columnNumber | cut -d% -f3`  
	colName=`grep "%," ./databases/$DB_name/$TableName | cut -d "," -f$columnNumber | cut -d% -f2`  

	echo "Column Name : $colName , it's Type : $columnType" 
	
	testPk=`grep "%," ./databases/$DB_name/$TableName | cut -d "," -f$columnNumber | grep %Pk% | cut -d% -f4` 
	
	echo -n "Enter the value of column number $columnNumber : ";
	read  val;

	#validation for string datatype
	if test $columnType = "string"
	then
		while [ -z $val ] 2>/dev/null || [[ $val =~ [\,\;\:\-\/\\] ]] || [ "$val" -eq "$val" ] 2>/dev/null
		do
			echo "Invalid input!, empty value or special characters are not allowed";
			echo -n "Enter the value of column number $columnNumber : ";
			read  val;
		done
	fi

	# Validation for integer datatype
	if test $columnType = "int"
	then
		while ! [ "$val" -eq "$val" ] 2>/dev/null
		do
			echo "Invalid input!, datatype of column number $columnNumber is integer";
			echo -n "Enter the value of column number $columnNumber : ";
			read  val;
		done
	fi

	#appending row to table with "," as delimeter
	if testPk=='Pk'
	then
		if checkNewValue=`cut -f$columnNumber -d, ./databases/$DB_name/$TableName | grep -w $val`
		then 
			echo "this value exit"
			main_menu/connectToDB.sh 
		else
			if test -z $row
			then
				row=$val
				else
					row=$row","$val;
			fi
		fi
	fi

done
echo "$row" >> ./databases/$DB_name/$TableName 2> /dev/null
echo "Your Data Updated Sucessfuly"
main_menu/connectToDB.sh 