#!/bin/bash

clear

source ./config.txt

cat Gametitle.txt | while IFS= read -r line; do echo -e "$line" ; done

# Get character name and weapon
read -p "What is your name Adventurer? (This will set your character name!) " name
cat $menu1
echo
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

#loads the Playerstate file and all Variables associated with the player themselves
source ./playerstate,txt

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
    damage=$((RANDOM % ( ($max_dmg - $min_dmg + 1) ) + Player_Strength))
	Monster_Health=$((Monster_Health - $damage))
	echo Orc takes $damage damage
	sleep 2
}
# Warriors lifegain attack
lifesteal() {
lfslcost=$(( 8 * Player_lvl ))
Player_Health=$(( $Player_Health - $lfslcost ))
damge=$((RANDOM % ( ($max_dmg - $min_dmg ) ) + 10 + Player_Strength))
lfsldmg=$(echo "($damage /100) + 0.5) | bc ")
Monster_Health=$((Monster_Health -$damage))
Player_Health=$(( $Player_health + $lfsldmg ))
}
# Monster attack
get_damage_mon() {
    damage=$((RANDOM % ($a2 - $a1 + $Monster_Strength) ))
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
f1="./Masset/o1.txt"
f2="./Masset/o2.txt"
f3="./Masset/o3.txt"
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
        1)  get_damage_user ; get_damage_mon ; clear ;;
        2)  get_damagem_user ; clear ; get_damage_mon ;;
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
	echo -e "$Gld $Player_lvl"
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

    if [ $seed -eq 0 ] && [ $Player_Strenght -le 19 ]; then 
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
    elif [ $seed -eq 4 ] && [ $Mountain_true == false ]; then
        echo "You find a trail leading you towards the mountains"
		Mountain_true=true
	else
		echo "Nothing new on the plains today"
    fi
}


# Main Loop
while [ $Player_Health -gt 0 ]; do
# NOTE TO SELF - MAKE IT SO YOU CAN ONLY REST ONCE PER 10 MINUTES SO PLAYERS CAN'T ABUSE RESTING TO HEAL AND WILL HAVE TO USE GOLD RESOURCES TO PAY TO SLEEP
if [Player
    echo "$menuget"
    read -p "Choose an action: " action 
    case $action in
        1) clear ; explore ;;
        2) clear ; Character_info ;;
        3) clear ; echo "resting..";  ; if sleep 2; Player_Health=$Player_MaxHealth ;;
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
