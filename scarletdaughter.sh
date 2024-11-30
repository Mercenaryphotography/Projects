#!/bin/bash

clear

#Font colour
R='\033[0;31m'   
G='\033[0;32m'   
Y='\033[1;32m'   
B='\033[0;34m'
P='\033[0;35m'
Gld='\033[0;93m'
Std='\033[0m'

# Graphic setup, makes a tempfolder downloads the files then points to files for the game to use.
echo "Acquiring image assets"
echo $titleurl
titleurl="https://raw.github.com/Mercenaryphotography/Projects/master/Gametitle.txt"
menuurl="https://raw.github.com/Mercenaryphotography/Projects/master/menu.txt"
file_contents=$(wget -qO- "$titleurl")
echo "$file_contents"


read -p "What is your name Adventurer? (This will set your character name!) " name
read -p "What is your weapon of choice? " weapon


#Starting Stats
Player_Health=100
Player_MaxHealth=100
Player_Experience=0
Player_Strength=15
Player_Defense=10
statusp=false
potion=false
weapon=$weapon

#Monster Pool

# Monster A
Amon_Health=20
Amon_experience=9
Amon_Strenght=10
Amon_Defense=8

# Monster B
Bmon_Health=60
Bmon_experience=20
Bmon_Strength=15
Bmon_Defense=10

# Monster C
Cmon_Health=100
Cmon_experience=100
Cmon_Strength=20
Cmon_Defense=15

# Base attack function for player
get_damage_user() {
	echo $((RANDOM % ($2 - $1 + $Player_strength) + $1))
	}
	
# Monster attack
get_damage_mon() {
	echo $((_RANDOM % ($2 -$1 + $Monster_strength) + $1))
	}

#Functions for User

Character_info() {
echo $name
echo -e $G HP $Std $Player_Health
echo -e $Gld Level up at 25 $Std $Player_Experience
echo -e $R Str $Std $Player_Strength
echo -e $B Def $Std $Player_Defense
if [ "$statusp" = "true" ] ; then
echo -e $P POISONED $std Antidote to Cure
else
echo HEALTHY
fi
}

# Location arry
locations=("Plains" "Cave" "Ruins" "Mountains" "River" "Lake")
# Player Actions

# Dmg function for random events
eventdmg() {
	echo $(( RANDOM % 8 + 1 )) ; echo
	}
# Explore function needs: Pull from a list of locations, locations have differnt odds of items, gold, or monster
explore() {
	#local random_location=${locations[ RANDOM % ${#locations[@]}]}
	
	#case $random_location in 
	#"Plains")

		#seed=$(( RANDOM % 5 ))
		seed=3
		if [ $seed -eq 0 ] ; then 
			echo "You explore the great plains to the west, you find no trouble, and the trip leaves you feeling healthy and hardy"
			Player_Strength=$((Player_Strength + 2))
		elif [ $seed -eq 1 ] ; then
			echo "You slink through the long grass of the great plains and find yourself suddenly chest to chest with an orc. You ready your weapon."
			# figure out how to start combat here
		elif [ $seed -eq 2 ] ; then
			echo "You find a merchant wandering the roads between the mountains and the capital, you offer them an escort and they gladly accept. You are gifted a potion for your troubles"
			potion=true
		elif [ $seed -eq 3 ] ; then
			damage=$(eventdmg)
			echo "you get lost, you have a hard time navigating the tall grass that gets ten feet tall in some patches of the golden plains. You suffer $damage damage"
			Player_Health=$((Player_Health - $damage))
			echo "you have $Player_Health left"
		elif [ $seed -eq 4 ] ; then
			echo "Not much out on the plains today"
	fi
	#;;
	#*)
	#	echo "You get lost and end up back at camp"
	#;;
	#esac
	}
			
while [ $Player_Health -gt 0 ]; do

	cat menu.txt
	echo
	read -p "Choose an action: " action
		case $action in
			1) explore ;;
			2) Character_info ;;
			3) echo "resting.."; sleep 2; Player_Health=$Player_MaxHealth ;;
			5) echo "good bye"; sleep 2 ; exit ;;
			*) echo "Invalid choice at this time" ;;
	
		esac
	done



while [ $Player_Health -le 1 ]; do

 echo "you have met an untimely end, good luck in your next life"
 exit
 
done