function main-menu
{
    echo -e "    +==============================================================+"
    echo -e "    |                       Main Menu                              |"
    echo -e "    |==============================================================|"
    echo -e "    |                    1.Create Database                         |"     
    echo -e "    |                    2.List Databases                          |"    
    echo -e "    |                    3.Connect To Databases                    |"    
    echo -e "    |                    4.Drop Database                           |"    
    echo -e "    |                    5.Exit                                    |"
    echo -e "    +==============================================================+"
    echo -e "Please choose a number : " 

    read userChoice
    case userChoice in

        1) main_menu/createDB.sh;;

        2) main_menu/listDB.sh;;

        3) main_menu/connectToDB.sh;;

        4) main_menu/dropDB.sh;;

        5) echo -e "ByeBye!";
		exit;;

        *) echo -e "invalid choice, please choose from the listed items!";
	main-menu 
    esac
}
main-menu
