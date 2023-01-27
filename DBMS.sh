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