################################################################################
########################### DBs Screen #########################################
################################################################################
# Create Database
function createDb {
	read -p "Enter Database Name: " DBNAME
	#############
	# null entry
	if [[ $DBNAME = "" ]]
	then
		echo -e "Invalid Entry, please Enter a Correct Name."
		sleep 1;
	#############
	# special characters
	elif [[ $DBNAME =~ [/.:\|\-] ]] 
	then
		echo -e "You can't Enter these Characters => . / : - | "
		sleep 1;
	#############
	# DB name exists		
	elif [[ -e $DBNAME ]] 
	then
		echo -e "This Database Name is already Exists."
		sleep 1;
	#############
	# new DB
	elif [[ $DBNAME =~ ^[a-zA-Z] ]]
	then
		mkdir -p "$DBNAME"
		cd "./$DBNAME" > /dev/null 2>&1
		newloc=`pwd`
		if [[ "$newloc" = `pwd` ]]
		then
			echo -e "Database Created Sucessfully in $(pwd)."
			sleep 1;
			dbsScreen=false
			tablesScreen=true
		else
			cd - > /dev/null 2>&1
			echo -e "can't access this location."
			sleep 1;
		fi
	#############
	# numbers or other special characters
	else
		echo -e "Database Name can't Start with Numbers or Special Characters."
		sleep 1;
	fi
}
################################################################################
# List of Databases
function listDb {
	# no databases exist
	if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d') = '' ]]
	then
		echo -e "There are no Databases here."
		sleep 1;
	############
	# databases exist
	else
		separator;
		echo -e "\t\tYour Existing Databases: \n$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')"
		separator;
		sleep 2;
		dbsScreen=true
		tablesScreen=false
	fi
}
################################################################################
# Connect to Database
function connectDb {
	# no databases exist
	if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d') = '' ]]
	then
		echo -e "There are no Databases here."
		sleep 1;
	############
	# databases exist
	else
		echo -e "\t\tYour Existing Databases: \n$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')"
		separator;
			read -p "Enter the name of the Database:  " DBNAME
			DBNAME="$DBNAME"
			############
			# null entry
			if [[ "$DBNAME" = '' ]] 
			then
				echo -e "Invalid Entry, Please Enter a Correct Name."
				sleep 1;
			############
			# DB doesn't exists
			elif ! [[ -d "$DBNAME" ]]
			then
				echo -e "This Database doesn't Exist."
				sleep 1;
			############
			# Connected to DB
			else
				cd "$DBNAME"
				separator;
				echo -e "The database Successfully Connected."
				sleep 1;
				dbsScreen=false
				tablesScreen=true
			fi
	fi
}
################################################################################
