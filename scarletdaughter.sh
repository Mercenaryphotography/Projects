#!/bin/bash

clear

source ./config.txt

echo "Acquiring image assets"
echo "$titleurl"
echo "$menuurl"
sleep 3
echo "Complete"
sleep 1
clear
echo "$titleget"

# Get character name and weapon
read -p "What is your name Adventurer? (This will set your character name!) " name
cat $menu1
read -p "What is your weapon of choice? " choice
echo " "
while true; do
	case $choice in
	1) class_weapon=Sword ; break ;;
	2) class_weapon=Staff ; break ;;
	3) class_weapon=Dagger ; break ;;
	*) echo "Invalid choice"
	esac
	done
clear

# Starting Stats
Player_Health=100
Player_MaxHealth=100 #Used for healing to full health
Player_exp=0 #Level ups increase base states depending on the level achieved.
Player_Strength=15	#Strength adds to the damage of your weapon
Player_Defense=10	#Defense subtracts from the enemey damage
Player_Luck=2		#Luck determines chance to run away
statusp=false       #Is the player Poisened?
potion=false		#Does the player have a potion on them (can only hold 1)
if [ $class_weapon = "Sword" ] ; then
min_dmg=3
max_dmg=5
elif [$class_weapon = "Staff" ] ; then
min_dmg=1
max_dmg=3
elif [$class_weapon = "Dagger" ] ; then
min_dmg=2
max_dmg=4
fi

1=$(min_dmg)
2=$(max_dmg)

# Monster Stats - I want to do an array style system where each zone can pull from 1 of 10 battles, and when it pulls the monster it randomly assigs their stats. 
Amon_Health=20
Amon_exp=9
Amon_Strength=10
Amon_Defense=8
a2=5
a1=2

Monster_Health=$Amon_Health
Monster_Strength=$Amon_Strength

# Base attack function for player
get_damage_user() {
    damage=$((RANDOM % ( ($2 - $1 + 1) ) + $1 + Player_Strength))
	Monster_Health=$((Monster_Health - $damage))
	echo Orc takes $damage damage
	sleep 2
}

# Monster attack
get_damage_mon() {
    damage=$((RANDOM % ($a2 - $a1 + $Monster_Strength) + $a1))
	Player_Health=$((Player_Health - $damage))
	echo You take $damage damage
	sleep 2
	
}
# Run from battle - Should make IF check a varaible grab depending on zone
coward () {
	run=$((RANDOM % 10 + 1 + $Player_Luck))
	if [ $run -gt 6  ]; then
	echo You get away
	sleep 2
	break
	else
	echo You are unable to escape
	get_damage_mon
	fi
}
# Load Monster Image
monsterimg() {
    count=0
# Cat the ascii art, pipe that into a loop that reads each line and inputs it one line at a time into a variable called line, then we
# Echo -e $line to display the txt files with their ansi codes inbedded
f1="/home/keagan/Bin/Game/Masset/o1.txt"
f2="/home/keagan/Bin/Game/Masset/o2.txt"
f3="/home/keagan/Bin/Game/Masset/o3.txt"
while [ $count -le 2 ] ; do
clear
cat $f1 | while IFS= read -r line; do echo -e "$line" ; done
sleep 0.25
clear
cat $f2 | while IFS= read -r line; do echo -e "$line" ; done
sleep 0.25
clear
cat $f3 | while IFS= read -r line; do echo -e "$line" ; done
sleep 0.25
let count++
done
}

# Battle System
fightfight() {
monsterimg
# I need to implement a system here to pick the monster type so it can call the right monsterimg files
    while true; do
		clear
		
       cat ./Masset/o3.txt | while IFS= read -r line; do echo -e "$line" ; done
        # Monster Image and Health always stays on screen during combat
        echo "Player Health: $Player_Health, Monster Health: $Monster_Health"
        cat $menu2
       #load the action menu and provides the actuall actions.
	   # NEED TO FIX COMBAT TO NOT APPLY DAMAGE IF THE MONSTER DIES BEFORE THEIR DAMAGE ACTION
	   read -p "Choose your action: " action
		case $action in
        1)  get_damage_user ; clear ; get_damage_mon ;;
        #2)  get_damagem_user ; clear ; get_damage_mon ;;
        #3) clear ; def_up ;clear ; get_damage_mon ;;
        4) coward ; clear ;;
        *) clear ; echo "Invalid choice" ;;
    esac
	if [ $Player_Health -le 1 ] ; then
	break
	elif [ $Monster_Health -le 1 ] ; then
	echo "Monster defeated! you gain $Amon_exp" experience points
	Player_exp=$((Player_exp + $Amon_exp))
	sleep 2
    break
	fi
    done
}

# Functions for User
Character_info() {
    echo "$name"
    echo -e "$G HP $Std $Player_Health"
    echo -e "$Gld Level up at 25 $Std $Player_Experience"
    echo -e "$R Str $Std $Player_Strength"
    echo -e "$B Def $Std $Player_Defense"
    if [ "$statusp" = "true" ]; then
        echo -e "$P POISONED $std Antidote to Cure"
    else
        echo "HEALTHY"
    fi
}

# Locations and Random Event Functions
locations=("Plains" "Cave" "Ruins" "Mountains" "River" "Lake")

eventdmg() {
    echo $((RANDOM % 8 + 1)) 
}

explore() {
    seed=$((RANDOM % 5))

    if [ $seed -eq 0 ]; then 
        echo "You explore the great plains to the west, you find no trouble, and the trip leaves you feeling healthy and hardy"
        Player_Strength=$((Player_Strength + 2))
    elif [ $seed -eq 1 ]; then
        echo "You slink through the long grass of the great plains and find yourself suddenly chest to chest with an orc. You ready your weapon."
		read -n 1 -srp "Hit any key to continue..." 	
        fightfight
    elif [ $seed -eq 2 ]; then
        echo "You find a merchant wandering the roads between the mountains and the capital, you offer them an escort and they gladly accept. You are gifted a potion for your troubles"
        potion=true
    elif [ $seed -eq 3 ]; then
        damage=$(eventdmg)
        echo "you get lost, you have a hard time navigating the tall grass that gets ten feet tall in some patches of the golden plains. You suffer $damage damage"
        Player_Health=$((Player_Health - $damage))
        echo "you have $Player_Health left"
    elif [ $seed -eq 4 ]; then
        echo "You find a trail leading you towards the mountains"
    fi
}

# Main Loop
while [ $Player_Health -gt 0 ]; do
    echo "$menuget"
    read -p "Choose an action: " action 
    case $action in
        1) clear ; explore ;;
        2) clear ; Character_info ;;
        3) clear ; echo "resting.."; sleep 2; Player_Health=$Player_MaxHealth ;;
        4) clear ; echo "testing damage" ; Player_Health=0 ;;
        5) clear ; echo "good bye"; sleep 2 ; exit ;;
        *) clear ; echo "Invalid choice" ;;
    esac

    while [ $Player_Health -le 1 ]; do
        echo "you have met an untimely end, good luck in your next life"
        read -p "Would you like to try again? (Y/N) " yn
        if [ "$yn" == "Y" ]; then
            Player_Health=$Player_MaxHealth
        elif [ "$yn" == "N" ]; then
            echo "Goodbye"
            sleep 1
            exit
        fi
    done
done
