#!/usr/bin/bash

# 				  $1		 $2			  $3
# match-data	$REPLY		$file 		$column

function check_dataType {
	datatype=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $2}')
	if [[ "$1" = '' ]]
	then
		echo 1
	elif [[ "$1" = -?(0) ]] 
	then
		echo 0 # error!
	elif [[ "$1" = ?(-)+([0-9])?(.)*([0-9]) ]] 
	then
		if [[ $datatype == integer ]]
		then
			# datatype integer and the input is integer
			echo 1
		else
			# datatype string and input is integer
			echo 1
		fi
	else
		if [[ $datatype == integer ]] 
		then
			# datatype integer and input is string
			echo 0 # error!
		else
			# datatype string and input is string
			echo 1
		fi
	fi
}
################################################################################
function check_size {
	datasize=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')
	if [[ "${#1}" -le $datasize ]] 
	then
		echo 1
	else
		echo 0 # error
	fi
}
################################################################################
# print separator
function separator {
	echo -e "\n************************************************************\n";
}
################################################################################
# Welcome Message
function welcomeMsg {
	echo -e "\n\tBash Shell Scripting Project - DBMS \n\tFull Stack Web Development using Python\n\tMerna Mamdouh & Aya Hassan\n";
}

# ------------------------------- database functions --------------------------------------

################################################################################
######################### Welcome Screen #######################################
################################################################################
function welcomeScreen {
	welcomeMsg;
	separator;
	select choice in "Enter to Our Database" "Exit"
	do
		case $REPLY in
			1 )
				if ! [[  -e `pwd`/DBMS ]]
                then
					mkdir -p ./DBMS
				fi
				cd ./DBMS/

				welcomeScreen=false
				dbsScreen=true
				separator;
                
				echo -e "Database is Loading... "
				sleep 1;
				;;
			2 )
				exit
				;;
			* )
				echo -e "Invalid Entry."
				sleep 1;
				;;
		esac
		break
	done 
}


################################################################################
######################### Tables Screen ########################################
################################################################################
# create tables' metadata
function createMetaData {
	# create the metadata
		if [[ -f "$dbtable" ]]
		then
			##########
			# num of cols
			validMetaData=true
			while $validMetaData
			do
				read -p "How Many Columns you want?  " num_col

				if [[ "$num_col" = +([1-9])*([0-9]) ]]
				then
					validMetaData=false
				else
					echo -e "Invalid Entry."
					sleep 1;
				fi
			done
			##########
			## pk name
			validMetaData=true
			while $validMetaData
			do
				read -p "Enter Primary Key Name: " pk_name
				#############
				# null entry
				if [[ $pk_name = "" ]] 
				then
					echo -e "Invalid Entry, Please Enter a Correct Name."
					sleep 1;
				#############
				# special characters
				elif [[ $pk_name =~ [/.:\|\-] ]]
				then
					echo -e "You can't Enter these Characters => . / : - | "
					sleep 1;
				############
				# valid entry
				elif [[ $pk_name =~ ^[a-zA-Z] ]] 
				then
					echo -n "$pk_name" >> "$dbtable"
					echo -n "-" >> "$dbtable"
					validMetaData=false
				#############
				# numbers or other special characters
				else
					echo -e " Primary Key can't Start with Numbers or Special Characters."
					sleep 1;
				fi
			done
			##########
			# pk dataType
			validMetaData=true
			while $validMetaData
			do
				echo -e "Enter Primary Key Datatype: "

				select choice in "integer" "string" 
				do
					if [[ "$REPLY" = "1" || "$REPLY" = "2" ]] 
					then
						echo -n "$choice" >> "$dbtable"
						echo -n "-" >> "$dbtable"
						validMetaData=false
					else
						echo -e "Invalid Choice."
						sleep 1;
					fi
					break
				done
			done
			########## 
			# pk size
			validMetaData=true
			while $validMetaData 
			do
				read -p "Enter Primary Key Size: " size
				 
				if [[ "$size" = +([1-9])*([0-9]) ]] 
				then
					echo -n "$size" >> "$dbtable"
					echo -n ":" >> "$dbtable"
					validMetaData=false
				else
					echo -e "Invalid Entry."
					sleep 1;
				fi
			done
			##########
			## to iterate over the enterd num of columns after the primary key, in order to enter its metadata
			for (( i = 1; i < num_col; i++ ))
			do
				##########
				# field name
				validMetaData=true
				while $validMetaData 
				do
					read -p "Enter Field $[i+1] Name: " field_name
					
					# null entry
					if [[ $field_name = "" ]]
					then
						echo -e "Invalid Entry, Please Enter a Correct Name."
						sleep 1;
					#############
					# special characters
					elif [[ $field_name =~ [/.:\|\-] ]] 
					then
						echo -e "You can't Enter these Characters => . / : - | "
						sleep 1;
					############
					# valid entry
					elif [[ $field_name =~ ^[a-zA-Z] ]] 
					then
						echo -n "$field_name" >> "$dbtable"
						echo -n "-" >> "$dbtable"
						sleep 1;
						validMetaData=false
					#############
					# numbers or other special characters
					else
						echo -e "Field Name can't Start with Numbers or Special Characters."
						sleep 1;
					fi
				done
				##########
				# field dataType
				validMetaData=true
				while $validMetaData
				do
					echo -e "Enter Field $[i+1] Datatype: "

					select choice in "integer" "string" 
					do
						if [[ "$REPLY" = "1" || "$REPLY" = "2" ]] 
						then
							echo -n "$choice" >> "$dbtable"
							echo -n "-" >> "$dbtable"
							sleep 1;
							validMetaData=false
						else
							echo -e "Invalid Choice."
							sleep 1;
						fi
						break
					done
				done
				##########
				# field size
				validMetaData=true
				while $validMetaData 
				do
					read -p "Enter Field $[i+1] Size: " size
					 
					if [[ "$size" = +([1-9])*([0-9]) ]] 
					then
						echo -n "$size" >> "$dbtable"
						##########
						# if last column
						if [[ i -eq $num_col-1 ]] 
						then
							echo $'' >> "$dbtable"
							echo -e "Table Created Successfully."
							sleep 1;
						##########
						# next column
						else
							echo -n ":" >> "$dbtable"
						fi
						validMetaData=false
					else
						echo -e "Invalid Entry."
						sleep 1;
					fi
				done
				##########
			done
			##########
		else
			echo -e "Invalid Entry." 
			sleep 1;
		fi
}

################################################################################
# Insert Data into Table
function insertData {
	# choose the table
	read -p "Enter Name of the table: " dbtable
	 
	# table not exist
	if ! [[ -f "$dbtable" ]] 
	then
		echo -e "This Table doesn't Exist."
		sleep 1;
	else
		##########
		## table exists
		insertingData=true
		while $insertingData  
		do
			# enter pk
			## => enter pk of type "id" of type integer and size 1
			echo -e "Enter Primary Key \"$(head -1 "$dbtable" |
			 	cut -d ':' -f1 | awk -F "-" '{print $1}')\" of type $(head -1 "$dbtable" |
			  	cut -d ':' -f1 | awk -F "-" '{print $2}') and size $(head -1 "$dbtable" |
			   	cut -d ':' -f1 | awk -F "-" '{print $3}')"

			read
			##########
			# match data & size
			check_type=$(check_dataType "$REPLY" "$dbtable" 1)
			check_size=$(check_size "$REPLY" "$dbtable" 1)
			#=> print all records except first record
			pk_used=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep -x -e "$REPLY") 
			##########
			# null entry
			if [[ "$REPLY" == '' ]] 
			then
				echo -e "No entry."
				sleep 1;
			#############
			# special characters
			elif [[ $REPLY =~ [/.:\|\-] ]]
			then
				echo -e "You can't Enter these Characters => . / : - | "
				sleep 1;
			##########
			# not matching datatype 
			elif [[ "$check_type" == 0 ]] 
			then 
				echo -e "Entry Invalid."
				sleep 1;
			##########
			# not matching size	
			elif [[ "$check_size" == 0 ]] 
			then
				echo -e "Entry Size Invalid."
				sleep 1;
			##########
			#! if primary key exists
			elif ! [[ "$pk_used" == '' ]] 
			then
				echo -e "This Primary Key is already Used."
				sleep 1;
			##########
			# primary key is valid
			else 
				echo -n "$REPLY" >> "$dbtable"
				echo -n ':' >> "$dbtable"

				# to get number of columns in table
				num_col=$(head -1 "$dbtable" | awk -F: '{print NF}')
				## to iterate over the columns after the primary key, in order to enter its data
				for (( i = 2; i <= num_col; i++ )) 
				do
					# enter other data
					inserting_other_data=true
					while $inserting_other_data 
					do
						echo -e "Enter \"$(head -1 "$dbtable" |
						 	cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" |
						  	cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" |
						   	cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $3}')"

						read
						##########
						# match data with its col datatype & size
						check_type=$(check_dataType "$REPLY" "$dbtable" "$i")
						check_size=$(check_size "$REPLY" "$dbtable" "$i")
						##########
						# not matching datatype
						if [[ "$check_type" == 0 ]] 
						then
							echo -e "Entry Invalid."
							sleep 1;
						##########
						# not matching size
						elif [[ "$check_size" == 0 ]] 
						then
							echo -e "Entry Size Invalid."
							sleep 1;
						#############
						# special characters
						elif [[ $REPLY =~ [/.:\|\-] ]] 
						then
							echo -e "You can't Enter these Characters => . / : - | "
							sleep 1;
						##########
						# entry is valid
						else
							##########
							# if last column
							if [[ i -eq $num_col ]] 
							then
								echo "$REPLY" >> "$dbtable"
								inserting_other_data=false
								insertingData=false
								echo -e "Entry Inserted Successfully."
							else
								##########
								# next column 
								echo -n "$REPLY": >> "$dbtable"
								inserting_other_data=false
							fi
						fi
					done
				done
			fi
		done
	fi
}
################################################################################
# Display Record (Row)
function displayRow {
	# choose table
	read -p "Enter Name of the table: " dbtable
	 
	# not exist
	if ! [[ -f "$dbtable" ]] 
	then
		echo -e "This Table doesn't Exist."
		sleep 1;
	else
		##########
		## table exists
		##########
		# enter pk
		echo "Enter Primary Key \"$(head -1 "$dbtable" | cut -d ':' -f1 |\
			awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable"\
			| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable"\
			| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record"

		read
		
		recordNum=$(cut -d ':' -f1 "$dbtable" | sed '1d'\
		| grep -x -n -e "$REPLY" | cut -d':' -f1)

		# null entry
		if [[ "$REPLY" == '' ]] 
		then
			echo -e "No Entry."
			sleep 1;
		##########
		# record not exists
		elif [[ "$recordNum" = '' ]] 
		then
			echo -e "This Primary Key doesn't Exist."
			sleep 1;
		##########
		# record exists
		else
			let recordNum=$recordNum+1
			num_col=$(head -1 "$dbtable" | awk -F: '{print NF}') 
			##########
			# to show the other values of record
			separator;
			echo -e "Fields and Values of this Record: "
			for (( i = 2; i <= num_col; i++ ))
			do
					echo \"$(head -1 $dbtable | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" : $(sed -n "${recordNum}p" 
						"$dbtable" | cut -d: -f$i)
			done
			separator;
		fi
	fi
}
################################################################################
# Delete Record (Row)
function deleteRecord {
	# choose table
	read -p "Enter Name of the table: " dbtable

	# not exist
	if ! [[ -f "$dbtable" ]] 
	then
		echo -e "This Table doesn't Exist."
		sleep 1;
	else
		##########
		# table exists
		##########
		# enter pk
		echo -e "enter primary key \"$(head -1 "$dbtable" |
		 	cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" |
		  	cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" |
		   	cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record to delete"
		
		read
		#########
		# get Number of this record
		recordNum=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$REPLY" | cut -d':' -f1)
													#! -x => exact match // -e => pattern // -n record number prefix

		##########
		# null entry
		if [[ "$REPLY" == '' ]] 
		then
			echo -e "No Entry."
			sleep 1;
		##########
		# record not exists
		elif [[ "$recordNum" = '' ]] 
		then
			echo -e "This Primary Key doesn't Exist."
			sleep 1;
		##########
		# record exists
		else
			let recordNum=$recordNum+1 #!=> recordNum is 0 based but sed is 1 based
			sed -i "${recordNum}d" "$dbtable"
			echo -e "Record Deleted Successfully."
			sleep 1;
		fi
	fi
}
################################################################################
# Update Table
function updateTable {
	# choose table
	read -p "Enter Name of the table: " dbtable

	# not exist
	if ! [[ -f "$dbtable" ]] 
	then
		echo -e "This Table doesn't Exist."
		sleep 1;
	else
		##########
		# table exists
		##########
		# enter pk
		echo "Enter Primary Key \"$(head -1 "$dbtable" | cut -d ':' -f1 |\
		awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record"
		
		read
		
		recordNum=$(cut -d ':' -f1 "$dbtable" | sed '1d'\
		| grep -x -n -e "$REPLY" | cut -d':' -f1)
		##########
		# null entry
		if [[ "$REPLY" == '' ]] 
		then
			echo -e "No Entry."
			sleep 1;
		##########
		# record not exists
		elif [[ "$recordNum" = '' ]] 
		then
			echo -e "This Primary Key doesn't Exist."
			sleep 1;
		##########
		# record exists
		else
			let recordNum=$recordNum+1
			##########
			# to get number of columns in table
			num_col=$(head -1 "$dbtable" | awk -F: '{print NF}') 
			##########
			# to show the other values of record
			separator;
			echo -e "Other Fields and Values of this Record: "
			for (( i = 2; i <= num_col; i++ )) 
			do
					echo \"$(head -1 $dbtable | cut -d ':' -f$i |\
					awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" | cut -d ':' -f$i |\
					awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" | cut -d ':' -f$i |\
					awk -F "-" 'BEGIN { RS = ":" } {print $3}'): $(sed -n "${recordNum}p" "$dbtable" | cut -d: -f$i)
			done
			separator;
			##########
			# to show the other fields' names of this record
			echo -e "Record Fields: "
			option=$(head -1 $dbtable | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}')
			echo "$option"
			getFieldName=true
			while $getFieldName 
			do
				separator;
				echo "Enter Field Name to Update"
				read
				##########
				# null entry
				if [[ "$REPLY" = '' ]] 
				then
					echo -e "Invalid Entry."
					sleep 1;
				##########
				# field name not exists
				elif [[ $(echo "$option" | grep -x "$REPLY") = "" ]]
				then
					echo -e "No such Field with the entered Name, Please Enter a Valid Field Name."
					sleep 1;
				##########
				# field name exists
				else
					# get field number
					fieldnum=$(head -1 "$dbtable" | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}'\
					| grep -x -n "$REPLY" | cut -d: -f1)

					updatingField=true
					while $updatingField 
					do
						##########
						# updating field's primary key
						if [[ "$fieldnum" = 1 ]] 
						then
							echo enter primary key \"$(head -1 "$dbtable" | cut -d ':' -f1 |\
							awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable"\
							| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable"\
							| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')

							read

							check_type=$(check_dataType "$REPLY" "$dbtable" 1)
							check_size=$(check_size "$REPLY" "$dbtable" 1)
							pk_used=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep -x -e "$REPLY")

							##########
							# null entry
							if [[ "$REPLY" == '' ]] 
							then
								echo -e "No Entry, Id can't be Null."
								sleep 1;
							##########
							#match datatype
							elif [[ "$check_type" == 0 ]] 
							then
								echo -e "Entry Invalid."
								sleep 1;
							##########
							# not matching size
							elif [[ "$check_size" == 0 ]] 
							then
								echo -e "Entry Size Invalid."
								sleep 1;
							##########
							# pk is used
							elif ! [[ "$pk_used" == '' ]] 
							then
								echo -e "This Primary Key already Used."
								sleep 1;
							##########
							# pk is valid
							else 
								awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY"\
								'BEGIN { FS = OFS = ":" } { if(NR == rn)	$fn = nv } 1' "$dbtable"\
								> "$dbtable".new && rm "$dbtable" && mv "$dbtable".new "$dbtable"

								updatingField=false
								getFieldName=false
							fi
						##########
						# updating other field 
						else
							updatingField=true
							while $updatingField 
							do
								echo enter \"$(head -1 $dbtable | cut -d ':' -f$fieldnum |\
								awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" | cut -d ':' -f$fieldnum |\
								awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" | cut -d ':' -f$fieldnum |\
								awk -F "-" 'BEGIN { RS = ":" } {print $3}')

								read

								check_type=$(check_dataType "$REPLY" "$dbtable" "$fieldnum")
								check_size=$(check_size "$REPLY" "$dbtable" "$fieldnum")

								##########
								# match datatype
								if [[ "$check_type" == 0 ]] 
								then
									echo -e "Entry Invalid."
									sleep 1;
								##########
								# not matching size
								elif [[ "$check_size" == 0 ]] 
								then
									echo -e "Entry Size Invalid."
									sleep 1;
								##########
								# entry is valid
								else
									awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY"\
									'BEGIN { FS = OFS = ":" } { if(NR == rn)	$fn = nv } 1' "$dbtable"\
									> "$dbtable".new && rm "$dbtable" && mv "$dbtable".new "$dbtable"

									updatingField=false
									getFieldName=false
								fi
							done
						fi
					done
					echo -e "Field Updated Successfully."
					sleep 1;
				fi
			done
		fi
		
	fi
}
################################################################################
# Select from Table
function selectMenu {
	separator;
	echo Databases:$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')
	separator;
		select choice in "Select All Columns from a Table" "Select Specific Column from a Table" "Select Specific Row from a Table" "Select From Table under condition" "Back" 
		do 
			case $REPLY in
				1 ) # Select All Columns from a Table
					separator;
					selectAll;
					;;
				2 ) # Select Specific Column from a Table
					separator;
					selectCol;
					;;	
				3 ) # Select Specific Row from a Table
					separator;
					selectRow;
					;;		
				4 ) # Select From Table under condition
					separator;
					selectCon;
					;;
				5 ) # Back
					cd ..
					welcomeScreen=false
					dbsScreen=false
					tablesScreen=true
					;;
				* )
					echo -e "Invalid Entry."
					sleep 1;
					;;
			esac
		break
		done
}
################################################################################
# Select All of Records
function selectAll {
	read -p "Enter Table Name: " tName
	 
	column -t -s ':' $tName 2>>./.error.log
	if [[ $? != 0 ]]
	then
		echo "Error Displaying Table $tName"
	fi
	selectMenu
}
################################################################################
# Select Column (Col)
function selectCol {
  read -p "Enter Table Name: " tName
  read -p "Enter Column Number: " colNum
 
  awk 'BEGIN{FS=":"}{print $'$colNum'}' $tName
  selectMenu
}
################################################################################
# Select Record (Row)
function selectRow {
	##########
	# choose table
	read -p "Enter Name of the table: " dbtable
	 
	##########
	# not exist
	if ! [[ -f "$dbtable" ]] 
	then
		echo -e "This Table doesn't Exist."
		sleep 1;
	else
		##########
		## table exists
		##########
		# enter pk
		echo enter primary key \"$(head -1 "$dbtable" | cut -d ':' -f1 |\
		awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record
		read
		
		recordNum=$(cut -d ':' -f1 "$dbtable" | sed '1d'\
		| grep -x -n -e "$REPLY" | cut -d':' -f1)
		##########
		# null entry
		if [[ "$REPLY" == '' ]] 
		then
			echo -e "No Entry."
			sleep 1;
		##########
		# record not exists
		elif [[ "$recordNum" = '' ]] 
		then
			echo -e "This Primary Key doesn't Exist."
			sleep 1;
		##########
		# record exists
		else
			let recordNum=$recordNum+1
			num_col=$(head -1 "$dbtable" | awk -F: '{print NF}') 
			##########
			# to show the other values of record
			separator;
			echo -e "fields and values of this record: "
			for (( i = 1; i <= num_col; i++ ))
			do
				echo \"$(head -1 $dbtable | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" : $(sed -n "${recordNum}p" "$dbtable" | cut -d: -f$i)
			done
			separator;
		fi
		sleep 2;
		selectMenu
	fi
}
################################################################################
# Select under Condition
function selectCon {
	separator;
		echo -e "\t\tYour Existing Databases:$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')"
		separator;
		select choice in "Select All Columns Matching Condition" "Select Specific Column Matching Condition" "Back To Selection Menu" "Back TO Tables Menu" 
		do 
			case $REPLY in
				1 ) # Select All Columns Matching Condition
					separator;
					allCond;
					;;
				2 ) # Select Specific Column Matching Condition
					separator;
					specCond;
					;;	
				3 ) # Back To Selection Menu 
					separator;
					selectMenu;
					;;		
				4 ) # Back TO Tables Menu 
					cd ..
					welcomeScreen=false
					dbsScreen=false
					tablesScreen=true
					;;
				* )
					echo -e "Invalid Entry."
					sleep 1;
					;;
			esac
		break
		done
}