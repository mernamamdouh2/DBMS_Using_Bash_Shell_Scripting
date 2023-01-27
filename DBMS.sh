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
